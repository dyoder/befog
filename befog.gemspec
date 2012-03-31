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
  s.summary     = "Distributed load testing tool"
  s.description = <<-EOF
		The befog gem allows you to quickly and easily run load tests
		using Ruby and Node.js. 
		EOF
  s.authors     = $authors
  s.email       = $emails
  s.require_path = "lib"
  s.files       = Dir["lib/befog/**/*.rb"] + %w[lib/befog.rb] + %w[bin/befog]
  s.homepage    =
    'https://github.com/spire-io/befog'
  s.add_runtime_dependency "spire_io", ["= 1.0.0.beta.3"]
	s.add_runtime_dependency "json", ["~> 1.6"]
	s.add_runtime_dependency "excon", ["~> 0.7"]
	s.add_runtime_dependency "mixlib-cli", ["~> 1.2.2"]
	s.add_runtime_dependency "highline", ["~> 1.6.11"]
	s.add_runtime_dependency "fog", ["~> 1.1.2"]
	s.add_development_dependency "rspec", ["~> 2.7"]
	s.add_development_dependency "yard", ["~> 0.7"]
end
