require "befog/commands/mixins/CLI"

module Befog
  module Commands
    module Mixins
      module Configurable
            
        def self.included(target)

          target.module_eval do

            include Mixins::CLI
        
            option :path, 
              :short => "-p PATH",
              :long => "--path PATH",
              :default => "~/.befog",
              :description => "Path to the configuration file you want to use"

            option :name,
              :short => "-n NAME",
              :long => "--name NAME",
              :default => "default",
              :description => "The name of this configuration"

          end
        end

        def configuration_path 
          @configuration_path = File.expand_path(options[:path])
        end
          
        def _configuration
          @configuration ||= (YAML.load_file(configuration_path) rescue {})
        end
        
        def configuration
          _configuration[options[:name]] ||= {}
        end

        def save
          File.open(File.expand_path(configuration_path),"w") { |f| YAML.dump(_configuration,f) }
        end
              

      end
    end
  end
end