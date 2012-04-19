module Befog
  module Commands
    module Mixins
      module Selectable
        def self.included(target)
          target.module_eval do
            
            option :provider,
              :short => :q,
              :description => "Select servers from this provider"

            option :region,
              :short => :r,
              :description => "Select servers from this region"

            option :image, 
              :short => :i,
              :description => "Select servers using this image"

            option :keypair, 
              :short => :x,
              :description => "Select servers using this keypair"

            option :group, 
              :short => :g,
              :description => "Select servers using this group"

            option :type, 
              :short => :t,
              :description => "Select servers of this type (flavor)"

            option :id,
              :short => :z,
              :description => "Select server with the given ID"

          end
        end
        
        def run_for_selected(&block)
          if bank? 
            servers.each(&block)
          else
            banks.keys.each do |name|
              options[:bank] = name
              if options[:id]
                block.call(options[:id]) if servers.include?(options[:id])
              else
                servers.each(&block) if ((provider? and (bank["provider"] == provider_name)) and
                  (region? and (bank["region"] == region)) and
                  (image? and (bank["image"] == image)) and
                  (security_group? and (bank["group"] == security_group)) and
                  (flavor? and (bank["type"] == flavor)))
              end
            end
          end
          
        end
      end
    end
  end
end
            
