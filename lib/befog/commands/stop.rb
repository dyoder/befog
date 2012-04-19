require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/selectable"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
  
    class Stop
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Selectable
      include Mixins::Safely
      include Mixins::Help

      command :name => :stop,
        :usage => "befog stop [<bank>] <options>",
        :default_to_help => true

      def run
        run_for_selected do |id|
          server = get_server(id)
          if server.state == "running"
            $stdout.puts "Stopping server #{id} ..."
            server.stop
          else
            $stdout.puts "Server #{id} is not (yet) running"
          end
        end
      end
    end
  end
end