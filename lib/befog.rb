module Befog
  VERSION = begin
    path = File.expand_path("../../VERSION", Pathname.new(__FILE__).realpath)
    File.read(path).chomp
  end
  
  def self.show_version
    $stdout.puts "Befog Version #{VERSION}"
  end
end

require "befog/cli"