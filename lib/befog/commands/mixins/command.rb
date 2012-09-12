require 'ostruct'

module Befog
  module Commands
    module Mixins
      module Command
        
        def self.included(target)
          target.module_eval do
            
            class << self 
              
              def command(descriptor=nil)
                descriptor ? (@command = OpenStruct.new(descriptor)) : @command
              end
              
              def option(name,descriptor)
                options << [name,descriptor]
              end
              
              def options ; @options||=[] ; end

              def run(options)
                Befog.show_version if options[:version] or options[:v]
                new(options).run
              end
              
            end
            
          end
        end
        
        attr_reader :options
        
        def initialize(_options)
          safely do
            @options = process_options(_options)
          end
        end
        
        def command
          self.class.command
        end
        
        # TODO: Support multi-line descriptions?
        def process_options(_options)
          if (command.default_to_help and _options.empty?) or _options[:help]
            usage
            exit(0)
          end
          self.class.options.each do |name,descriptor|
            short, required, default, type = descriptor.values_at(:short,:required,:default,:type)
            _options[name] ||= (_options[short]||default)
            _options.delete(short)
            if required and not _options[name]
              error("Missing required option --#{name}")
            end
          end
          # TODO: add type conversion
          return _options
        end
        
        def usage
          $stderr.puts command.usage
          usage = []
          self.class.options.each do |name,descriptor|
            short, required, default, description = descriptor.values_at(:short,:required,:default,:description)
            required = (required ? "(required) " : "")
            default = (default ? "(default: #{default}) " : "")
            usage << "\t%-3s %-20s\t%-40s" % ["-#{short},", "--#{name} #{name.to_s.upcase}", "#{description} #{required}#{default}"]
          end
          $stderr.puts *(usage.sort)
        end
        
        
        
        def error(message)
          raise CLI::Error.new(message)
        end
        
        def log(message)
          $stdout.puts(message)
        end
      end
    end
  end
end
            
