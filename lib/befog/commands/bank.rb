require "befog/commands/bank/add"
require "befog/commands/bank/remove"
require "befog/commands/bank/start"
require "befog/commands/bank/stop"
require "befog/commands/bank/run"

module Befog
  module Commands
    
    # This is the befog command
    module Bank

      include Mixins::Configurable

      COMMANDS = {
        "add" => Befog::Commands::Bank::Add,
        "remove" => Befog::Commands::Bank::Remove,
        "start" => Befog::Commands::Bank::Start,
        "stop" => Befog::Commands::Bank::Stop,
        "run" => Befog::Commands::Bank::Run
      }
      
      def self.run(args)
        subcommand, *args = args
        if command = COMMANDS[subcommand]
          begin
            command.run(args)
          rescue => e
            $stderr.puts "befog bank: #{e.message}"
            exit(-1)
          end
        else
          if subcommand
            usage "'#{subcommand}' is not a supported command"
          else
            usage "No subcommand provided."
          end
        end
      end
      
      def self.usage(message)
        $stderr.puts "befog bank: #{message}"
        $stderr.puts <<-eos
        
Usage: befog bank <subcommand> <options>

Provision and deprovision banks or deploy scenarios to banks. 

Valid commands:

    add         Provision new banks
    remove      Deprovision banks
    deploy      Deploy a scenario to banks
    start       Start the bank listeners
    stop        Stop the bank listeners
    run         Run a shell command on all the servers
    
You can get more options for any command with --help or -h.
eos
        exit(-1)
      end
      
    end
  end
end