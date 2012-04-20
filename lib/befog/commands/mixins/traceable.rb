module Befog
  module Commands
    module Mixins
      module Traceable
        def self.included(target)
          target.module_eval do
            option :rehearse,
              :short => :u,
              :description => "Dry-run, verbose logging, but don't actually run anything"
          end
        end
        
        def rehearse?
          !!options[:rehearse]
        end
        
        def verbose?
          !!options[:verbose] or rehearse?
        end
        
        def verbose(message)
          log(message) if verbose?
        end
        
      end
    end
  end
end
            
