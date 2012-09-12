require "rake/clean"

CLEAN << FileList["*.gem"]
CLEAN << FileList["doc/*"]
CLEAN << ".yardoc"

$version = File.read("VERSION").chomp

desc "run yardoc"
task :doc do
	sh "yard"
end

desc "run tests"
task :test do
	sh ".rspec #{FileList["test/*.rb"]}"
end

task :gem => :update do
	sh "gem build befog.gemspec"
end

task :update do
  # no-op for now
end

desc "generate docs and build a gem"
task :package => [:doc, :gem]

desc "publish the gem"
task :publish => :package do
  version = File.read("VERSION").chomp
  sh "gem push befog-#{version}.gem"
end

desc "build and install the gem"
task :install => :package do
	sh "gem install befog-#{$version}.gem"
end
