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
        :description => "Command to run"
      
      option :shell,
        :short => :y,
        :description => "Shell script to run remotely"
    
      option :all,
        :short => :a,
        :description => "Deprovision all selected servers"

    
      def run
        script = if options[:command] and not options[:shell]
          $stdout.puts "Running command '#{options[:command]}' ..."
          options[:command]
        elsif options[:shell] and not options[:command]
          $stdout.puts "Running script '#{options[:shell]}' ..."
          # We add the sleep in case the last command is run in the bg
          File.open options[:shell] { |file| file.read + "\nsleep 1"}
        else
          raise "Must specify one of --shell or --command"
        end
        run_for_selected do |id|
          threads = []; threads << Thread.new do
            safely do
              # TODO: Add check to see if we have a bad ID in the config
              server = get_server(id)
              if server.state == "running"
                address = server.public_ip_address
                $stdout.puts "... for '#{address}'"
                result = Fog::SSH.new(address, "root").run(script).first
                $stdout.puts "#{address} STDOUT: #{result.stdout}"
                $stderr.puts "#{address} STDERR: #{result.stderr}" unless result.stderr.empty?
              else
                $stdout.puts "Server #{id} isn't running - skipping"
              end
            end
          end
          sleep 1 while threads.any? { |t| t.alive? }
        end
      end

    end
  end
end