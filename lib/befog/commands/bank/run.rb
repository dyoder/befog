require "yaml"
require "befog/commands/mixins/help"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/aws"
require "befog/commands/mixins/server"
require "mixlib/cli"

module Befog
  module Commands
    
    module Bank
      
      class Run
      
        include Mixlib::CLI
        include Mixins::Help
        include Mixins::Configurable
        include Mixins::Bank
        include Mixins::AWS
        include Mixins::Server

        option :command, 
          :short => "-c COMMAND",
          :long  => "--command COMMAND",
          :required => true,
          :description => "Command to run"

        def run_for_server(id)
          Fog::SSH.new(server.public_ip_address, "root").run("npm --version").first.stdout
        end
        
      end
    end
  end
end