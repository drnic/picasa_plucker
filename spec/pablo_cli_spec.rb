require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'pablo/cli'

describe Pablo::CLI, "execute" do
  before(:each) do
    @stdout_io, @stderr_io = StringIO.new, StringIO.new
    Pablo::CLI.execute(@stdout_io, [])
    @stdout_io.rewind; @stderr_io.rewind
    @stdout, @stderr = @stdout_io.read, @stderr_io.read
  end
  
  it "should print default output" do
    @stderr.should =~ /Fetching album information.../
  end
end