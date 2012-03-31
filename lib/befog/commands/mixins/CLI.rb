module Befog
  module Commands
    module Mixins
      module CLI
        
        def self.included(target)
          target.module_eval do
            
            class << self 
              
              def command(name,descriptor)
                @command = (Struct.new(:name,:descriptor)).new(name,descriptor)
              end
              
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

            end
            
          end
        end
        
      end
    end
  end
end
            
