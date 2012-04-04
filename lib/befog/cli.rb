require "befog/commands/add"
require "befog/commands/remove"
require "befog/commands/start"
require "befog/commands/stop"
require "befog/commands/run"
require "befog/commands/list"
require "befog/commands/configure"

module Befog
  
  module CLI
    
    class Error < RuntimeError ; end

    COMMANDS = {
      "add" => Befog::Commands::Add,
      "remove" => Befog::Commands::Remove,
      "start" => Befog::Commands::Start,
      "stop" => Befog::Commands::Stop,
      "run" => Befog::Commands::Run,
      "list" => Befog::Commands::List,
      "ls" => Befog::Commands::List,
      "configure" => Befog::Commands::Configure,
      "config" => Befog::Commands::Configure
    }
    
    def self.run(subcommand=nil,*args)
      if command = COMMANDS[subcommand]
        begin
          command.run(args)
          
        # TODO: use a befog-specific error class to 
        # differentiate between expected exceptions
        # (just display the error message) and un-
        # expected (display the backtrace)
        rescue Befog::CLI::Error => e
          $stderr.puts "befog: #{e.message}"
          exit(-1)
        rescue => e # uh-oh
          $stderr.puts "Unexpected error"
          $stderr.puts "#{e.class}: #{e.message}"
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
      $stderr.puts "befog: #{message}"
      $stderr.puts <<-eos
        
Usage: befog <subcommand> [<bank>] [<options>]

The befog command allows you to manage your cloud servers from the command line.
You reference these sets of servers as banks.  A bank can have one or many servers.

Example: befog add web-servers --count 3

Adds 3 servers to the bank "web-servers"

Valid commands:

    configure   Configure a bank of servers
    config
    add         Provision new servers for a bank of servers
    remove      De-provision servers for a bank of servers
    start       Start a bank of servers
    stop        Stop (suspend) a bank of servers
    run         Run a command on each of a bank of servers
    list,ls     List all servers with optional bank, region, or provider
    
You can get more options for any command with --help or -h.
eos
      exit(-1)
      
    end
  end
end
