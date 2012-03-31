require "befog/commands/configure"
require "befog/commands/bank"

module Befog
  module CLI

    COMMANDS = {
      "configure" => Befog::Commands::Configure,
      "config" => Befog::Commands::Configure,
      "bank" => Befog::Commands::Bank
    }
    
    def self.run(subcommand=nil,*args)
      if command = COMMANDS[subcommand]
        begin
          command.run(args)
        rescue => e
          $stderr.puts "befog: #{e.message}"
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
      $stderr.puts "befog: #{message}"
      $stderr.puts <<-eos
        
Usage: befog <subcommand> <options>

The befog command provides command line access to the spire.io API. 

Valid commands:

    configure,   Configure befog, ex: set your AWS key
    config
      
    bank         (De-)provision servers for a bank
    
You can get more options for any command with --help or -h.
eos
      exit(-1)
      
    end
  end
end