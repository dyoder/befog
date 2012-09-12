require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/selectable"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class List
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Safely
      include Mixins::Selectable
      include Mixins::Help

      command :name => :list,
        :usage => "befog list [<bank>] <options>",
        :default_to_help => true

  
      option :all,
        :short => :a,
        :description => "List all selected servers"


      def run
        run_for_selected do |id|
          server = compute.servers.get(id)
          log "%-15s %-15s %-15s %-45s %-10s" % [id,server.flavor_id,server.tags["Name"],(server.dns_name||"-"),server.state]
        end
      end
    end
  end
end
