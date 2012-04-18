module Befog
  module Commands
    module Mixins
      module Configurable
            
        def self.included(target)

          target.module_eval do

            option :path, 
              :short => :p, :default => "~/.befog",
              :description => "Path to the configuration file"

            option :name,
              :short => :n, :default => "default",
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
          _configuration[configuration_name] ||= {}
        end
        
        def configuration_name
          options[:name]
        end

        def save
          File.open(File.expand_path(configuration_path),"w") { |f| YAML.dump(_configuration,f) }
          $stdout.puts "Configuration written to: #{configuration_path}"
        end
              

      end
    end
  end
end