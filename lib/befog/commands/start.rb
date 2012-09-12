require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/selectable"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class Start
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Safely
      include Mixins::Selectable
      include Mixins::Help

      command :name => :start,
        :usage => "befog start [<bank>] [<options>]",
        :default_to_help => true

      option :all,
        :short => :a,
        :description => "Start all selected servers"

      def run
        run_for_selected do |id|
          server = get_server(id)
          if server.state == "stopped"
            $stdout.puts "Starting server #{id} ..."
            server.start
          else
            $stdout.puts "Server #{id} is already (or still) running"
          end
        end
      end

    end
  end
end