module Befog
  module Commands
    module Mixins
      module Help
        def self.included(target)
          target.module_eval do
            option :help,
              :short => :h,
              :description => "Show this message"
          end
        end
        
      end
    end
  end
end
            
