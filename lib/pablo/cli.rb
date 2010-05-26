require 'optparse'

module Pablo
  class CLI
    def self.execute(stdout, stderr, arguments=[])

      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.

      options = {
        :path     => '.'
      }

      parser = OptionParser.new do |opts|
        opts.banner = <<-BANNER.gsub(/^          /,'')
          Downloads all images from a picasa web album.

          Usage: #{File.basename($0)} album_url [options]

          Options are:
        BANNER
        opts.separator ""
        # opts.on("-p", "--path PATH", String,
        #         "This is a sample message.",
        #         "For multiple lines, add more strings.",
        #         "Default: .") { |arg| options[:path] = arg }
        opts.on("-h", "--help",
                "Show this help message.") { stdout.puts opts; exit }
        opts.parse!(arguments)
      end
      
      require_curl stderr

      begin
        path = options[:path]
        url  = arguments.shift
        if url =~ %r{picasaweb\.google\.[^\\]+\/([^\\]+)\/([^\\?]+)}
          picasa_user, picasa_album = $1, $2
          FileUtils.mkdir_p(path)
          FileUtils.chdir(path) do
            FileUtils.mkdir_p(album_path = File.join(picasa_user, picasa_album))
            FileUtils.chdir(album_path) do
              fetch_album_images(url, stdout, stderr)
            end
          end
        else
          stdout.puts parser; exit
        end
      rescue Interrupt
      rescue SystemExit
      end
    end
    
    def self.fetch_album_images(url, stdout = STDOUT, stderr = STDERR)
      require "open-uri"
      require "hpricot"
      require "progressbar"
    
      stderr.puts "Fetching album information..."
      begin
        doc = Hpricot(open(url))
      rescue OpenURI::HTTPError
        stderr.puts "Cannot find album at url: #{url}"; exit
      end
      images = doc.search("//noscript/div/a")
      if images.size > 0
        pbar = ProgressBar.new("Downloading", images.size, stderr)
        pbar.set(0)
        images.each do |image|
          thumbnail_url = image.search("/img").first["src"]
          image_url = thumbnail_url.sub(%r{/s\d+}, '')
          
          # http://lh4.ggpht.com/_SRH16SUjNaU/S-2_vpVwwZI/AAAAAAAABfI/0892I3WCOPU/IMG_4016.JPG
          # http://lh3.ggpht.com/_SRH16SUjNaU/S-2_vviX93I/AAAAAAAABfM/kxV884geg7Q/IMG_4017.JPG
          # http://lh4.ggpht.com/_SRH16SUjNaU/S-2_v5B7H0I/AAAAAAAABfQ/5_n1YGywxv0/IMG_4018.JPG
          image_file = File.basename(image_url)
          system "curl '#{image_url}' -o '#{image_file}' --silent"
          pbar.inc
        end
        pbar.finish
      else
        stderr.puts "Cannot find any images"; exit
      end
    end
    
    def self.require_curl(stderr)
      if `which curl`.strip == ""
        stderr.puts "Please install 'curl' to use pablo. Sorry about that."; exit
      end
    end
  end
end
