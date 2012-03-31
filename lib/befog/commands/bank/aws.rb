require "befog/commands/bank/aws/add"
require "befog/commands/bank/aws/remove"
require "befog/commands/bank/aws/start"
require "befog/commands/bank/aws/stop"
require "befog/commands/bank/aws/run"

module Befog
  module Commands
    
    # This is the befog command
    module Bank
      
      module AWS

        include Mixins::Configurable

        COMMANDS = {
          "add" => Befog::Commands::Bank::AWS::Add,
          "remove" => Befog::Commands::Bank::AWS::Remove,
          "start" => Befog::Commands::Bank::AWS::Start,
          "stop" => Befog::Commands::Bank::AWS::Stop,
          "run" => Befog::Commands::Bank::AWS::Run
        }
      
        def self.run(args)
          subcommand, *args = args
          if command = COMMANDS[subcommand]
            begin
              command.run(args)
            rescue => e
              $stderr.puts "befog bank aws: #{e.message}"
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

  Provision and deprovision servers for server banks. 

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
end