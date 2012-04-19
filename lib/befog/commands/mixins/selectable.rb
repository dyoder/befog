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
                servers.each(&block) if ((not provider? or (bank["provider"] == provider_name)) and
                  (not region? or (bank["region"] == region)) and
                  (not image? or (bank["image"] == image)) and
                  (not security_group? or (bank["group"] == security_group)) and
                  (not flavor? or (bank["type"] == flavor)))
              end
            end
          end
          
        end
      end
    end
  end
end
            
