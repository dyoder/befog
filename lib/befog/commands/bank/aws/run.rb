require "yaml"
require "fog"
require "befog/commands/mixins/help"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/aws"
require "befog/commands/mixins/server"

module Befog
  module Commands
    
    module Bank
      
      module AWS
      
        class Run
      
          include Mixlib::CLI
          include Mixins::Configurable
          include Mixins::Bank
          include Mixins::AWS
          include Mixins::Server
          include Mixins::Help

          command "befog bank aws run",
            :default_to_help => true

          option :command, 
            :short => "-c COMMAND",
            :long  => "--command COMMAND",
            :required => true,
            :description => "Command to run (required)"

          def run_for_server(id)
            address = get_server(id).public_ip_address
            result = Fog::SSH.new(address, "root").run(options[:command]).first
            $stdout.puts "[#{address}: STDOUT] #{result.stdout}"
            $stderr.puts "[#{address}: STDERR] #{result.stderr}"
          end

        end
      end
    end
  end
end