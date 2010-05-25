require 'optparse'

module Pablo
  class CLI
    def self.execute(stdout, arguments=[])

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

      path = options[:path]
      url  = arguments.shift
      if url =~ %r{picasaweb\.google\.[^\\]+\/([^\\]+)\/([^\\?]+)}
        picasa_user, picasa_album = $1, $2
        FileUtils.mkdir_p(path)
        FileUtils.chdir(path) do
          FileUtils.mkdir_p(album_path = File.join(picasa_user, picasa_album))
          FileUtils.chdir(album_path) do
            p `pwd`
          end
        end
      else
        stdout.puts parser; exit
      end
    end
  end
end
