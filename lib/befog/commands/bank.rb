require "befog/commands/bank/aws"

module Befog
  
  module Commands
    
    module Bank

      COMMANDS = {
        "aws" => Befog::Commands::Bank::AWS,
      }
      
      def self.run(args)
        subcommand, *args = args
        if command = COMMANDS[subcommand]
          begin
            command.run(args)
          rescue => e
            $stderr.puts "befog bank: #{e.message}"
            $stderr.puts e.backtrace

            
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

Set befog configuration options. 

Valid commands:

    aws         Provision a bank using AWS
    
You can get more options for any command with --help or -h.
eos
        exit(-1)
      end
      
    end
  end
end