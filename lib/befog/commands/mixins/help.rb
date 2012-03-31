module Befog
  module Commands
    module Mixins
      module Help
        def self.included(target)
          target.module_eval do
            include Mixins::CLI
            option :help,
              :short => "-h",
              :long => "--help",
              :description => "Show this message",
              :help => true
          end
        end
        
      end
    end
  end
end
            
