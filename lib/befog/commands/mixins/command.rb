require "optparse"

module Befog
  module Commands
    module Mixins
      module Command
        
        def self.included(target)
          target.module_eval do
            
            class << self 
              
              def command(name,descriptor)
                @command = (Struct.new(:name,:descriptor)).new(name,descriptor)
              end
              
              def specification ; @command ; end
              
              def option(name,descriptor)
                options << [name,descriptor]
              end
              
              def options ; @options||=[] ; end

              # TODO: Support multi-line descriptions?
              def process_arguments(arguments)
                results = {}; required = [] 
                parser = OptionParser.new do |parser|
                  parser.banner = "Usage: #{@command.name} [options]"
                  options.each do |name,descriptor|
                    if descriptor[:help]
                      parser.on_tail(*descriptor.values_at(:short,:long,:description)) do |value|
                        $stdout.puts parser
                        exit(0)
                      end
                    else
                      results[name] = descriptor[:default] if descriptor[:default]
                      required << name if descriptor[:required]
                      parser.on(*descriptor.values_at(:short,:long,:description)) do |value|
                        results[name] = value
                      end
                    end
                  end
                end
                if @command.descriptor[:default_to_help] and arguments.empty?
                  $stdout.puts parser
                  exit(0)
                end
                parser.parse!(arguments)
                required.each do |name|
                  unless results[name]
                    $stderr.puts "Missing required option '#{name}'"
                    $stderr.puts parser
                    exit(-1)
                  end
                end
                results
              end
              
              def run(arguments)
                new(arguments).run
              end

            end
            
          end
        end
        
        attr_reader :options
        
        def initialize(arguments)
          process_arguments(arguments)
        end

        def process_arguments(arguments)
          @options = self.class.process_arguments(arguments)
        end
        
        def required(value,message)
          raise CLI::Error.new(message) if value.nil?
        end
        
        def warning(value,message)
          log message if value.nil?
        end
        
        def log(message)
          $stdout.puts(message)
        end
      end
    end
  end
end
            
