require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/server"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class Start
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Bank
      include Mixins::Provider
      include Mixins::Server
      include Mixins::Help

      command "befog start <bank>",
        :default_to_help => true

      def run
        run_for_each_server
      end

      def run_for_server(id)
      end

    end
  end
end