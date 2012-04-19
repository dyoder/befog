require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/selectable"
require "befog/commands/mixins/help"


module Befog
  module Commands
    
    class Run
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Safely
      include Mixins::Selectable
      include Mixins::Help

      command :name => :run,
        :usage => "befog run [<bank>] <options>",
        :default_to_help => true

      option :command, 
        :short => :c,
        :required => true,
        :description => "Command to run (required)"
    
      option :all,
        :short => :a,
        :description => "Deprovision all selected servers"

    
      def run
        run_for_selected do |id|
          $stdout.puts "Running command '#{options[:command]}' for #{address} ..."
          Thread.new do
            safely do
              server = get_server(id)
              if server.state == "running"
                address = server.public_ip_address
                result = Fog::SSH.new(address, "root").run(options[:command]).first
                $stdout.puts "#{address} STDOUT #{result.stdout}"
                $stderr.puts "#{address} STDERR #{result.stderr}" if result.stderr
              else
                $stdout.puts "Server #{id} isn't running - skipping"
              end
            end
          end
        end
      end

    end
  end
end