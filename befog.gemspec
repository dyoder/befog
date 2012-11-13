$version = File.read("VERSION").chomp
$authors = []
$emails = []
File.open "AUTHORS","r" do |file|
	authors = file.read
	authors.split("\n").map do |author|
		name, email = author.split("\t")
		$authors << name ; $emails << email
	end
end

Gem::Specification.new do |s|
  s.name        = 'befog'
  s.version     = $version
  s.summary     = "Cloud provisioning CLI"
  s.description = <<-EOF
		The befog gem allows you to manage your cloud servers
		directly from the command-line. 
		EOF
  s.authors     = $authors
  s.email       = $emails
  s.require_path = "lib"
  s.files       = Dir["lib/befog/**/*.rb"] + %w[lib/befog.rb] + %w[bin/befog] + %w[ VERSION AUTHORS Readme.md]
  s.bindir      = "bin"
  s.executables << "befog"
  s.default_executable = "befog"
  s.homepage    =
    'https://github.com/dyoder/befog'
	s.add_runtime_dependency "fog", ["~> 1.3"]
	s.add_development_dependency "rspec", ["~> 2.7"]
	s.add_development_dependency "yard", ["~> 0.7"]
end
