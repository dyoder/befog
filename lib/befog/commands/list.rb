require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class List
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Safely
      include Mixins::Help

      command :name => :list,
        :usage => "befog list [<bank>] [<options>]",
        :default_to_help => false

      option :provider,
        :short => :q,
        :description => "List all servers from this provider"

      option :region,
        :short => :r,
        :description => "List all servers from this region"

      option :image, 
        :short => :i,
        :description => "List all servers using this image"

      option :keypair, 
        :short => :x,
        :description => "List all servers using this keypair"

      option :group, 
        :short => :g,
        :description => "List all servers using this group"

      option :type, 
        :short => :t,
        :description => "List all servers of this type (flavor)"


      def run
        if bank? 
          list_bank
        else
          list_all
        end
      end
      
      def list_all
        banks.keys.each do |name|
          options[:bank] = name
          list_bank if ((provider? and (bank["provider"] == provider_name)) and
            (region? and (bank["region"] == region)) and
            (image? and (bank["image"] == image)) and
            (security_group? and (bank["group"] == security_group)) and
            (flavor? and (bank["type"] == flavor)))
        end
          
      end
      
      def list_bank
        servers.each do |id|
          server = compute.servers.get(id)
          log "%-15s %-15s %-15s %-45s %-10s" % [id,server.flavor_id,server.tags["Name"],(server.dns_name||"-"),server.state]
        end
      end

    end
  end
end
