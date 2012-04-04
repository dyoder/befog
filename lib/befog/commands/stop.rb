require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/server"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
  
    class Stop
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Bank
      include Mixins::Provider
      include Mixins::Server
      include Mixins::Help

      command "befog stop <bank>",
        :default_to_help => false

      def run
        run_for_each_server
      end

      def run_for_server(id)
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