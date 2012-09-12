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
          # Make sure we load the configuration before opening the file for writing
          configuration_for_writing = _configuration
          File.open(configuration_path,"w") { |f| YAML.dump(configuration_for_writing,f) }
          $stdout.puts "Configuration written to: #{configuration_path}"
        end
              

      end
    end
  end
end