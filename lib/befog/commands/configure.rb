require "befog/commands/configure/aws"

module Befog
  
  module Commands
    
    module Configure

      COMMANDS = {
        "aws" => Befog::Commands::Configure::AWS,
      }
      
      def self.run(args)
        subcommand, *args = args
        if command = COMMANDS[subcommand]
          begin
            command.run(args)
          rescue => e
            $stderr.puts "befog configure: #{e.message}"
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
        $stderr.puts "befog configure: #{message}"
        $stderr.puts <<-eos
        
Usage: befog configure <subcommand> <options>

Set befog configuration options. 

Valid commands:

    aws         Configure AWS
    
You can get more options for any command with --help or -h.
eos
        exit(-1)
      end
      
    end
  end
end