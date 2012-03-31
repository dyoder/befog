require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/server"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class List
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Bank
      include Mixins::Provider
      include Mixins::Server
      include Mixins::Help

      command "befog list [<bank>]",
        :default_to_help => true

      def run
      end

    end
  end
end