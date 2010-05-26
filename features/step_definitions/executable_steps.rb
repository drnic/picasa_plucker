When /^I run executable internally with arguments "([^\"]*)"$/ do |args|
  require "pablo/cli"
  @stdout = File.expand_path(File.join(@tmp_root, "executable.out"))
  @stderr = File.expand_path(File.join(@tmp_root, "executable.err"))
  in_project_folder do
    Pablo::CLI.execute(@stdout_io = StringIO.new, @stderr_io = StringIO.new, args.split(" "))
    File.open(@stdout, "w") { |f| @stdout_io.rewind; f << @stdout_io.read }
    File.open(@stderr, "w") { |f| @stderr_io.rewind; f << @stderr_io.read }
  end
end
