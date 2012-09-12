require "befog/commands/add"
require "befog/commands/remove"
require "befog/commands/start"
require "befog/commands/stop"
require "befog/commands/run"
require "befog/commands/list"
require "befog/commands/configure"
require "befog/commands/mixins/safely"

module Befog
  
  module CLI
    
    class Error < RuntimeError ; end
    
    extend Befog::Commands::Mixins::Safely
    
    COMMANDS = {
      "add" => Befog::Commands::Add,
      "remove" => Befog::Commands::Remove,
      "rm" => Befog::Commands::Remove,
      "start" => Befog::Commands::Start,
      "stop" => Befog::Commands::Stop,
      "run" => Befog::Commands::Run,
      "list" => Befog::Commands::List,
      "ls" => Befog::Commands::List,
      "configure" => Befog::Commands::Configure,
      "config" => Befog::Commands::Configure
    }
    
    def self.parse(arguments)
      options = {}
      key = :bank
      while not arguments.empty?
        argument = arguments.shift
        flag, short, long = /^(?:\-(\w)|\-\-(\w+))$/.match(argument).to_a
        if flag
          key = (short or long).to_sym
          options[key] = true
        else
          case options[key]
          when Array then options[key] << argument
          when String then options[key] = [ options[key], argument ]
          when true, nil then options[key] = argument
          end
        end
      end
      return options
    end
    
    def self.run(arguments)
      subcommand = arguments.shift
      # TODO: Rejigger this so we can have top-level options
      # instead of special-casing --version
      if subcommand == "--version" or subcommand == "-v"
        Befog.show_version
        exit if arguments.empty?
        subcommand = arguments.shift
      end
      if subcommand && (command = COMMANDS[subcommand])
        command.run(CLI.parse(arguments))
      elsif subcommand
        usage "'#{subcommand}' is not a supported command"
      else
        usage
      end
    end
    
    def self.usage(message=nil)
      $stderr.puts "befog: #{message}" if message
      $stderr.puts <<-eos
        
Usage: befog <subcommand> [<bank>] [<options>]

The befog command allows you to manage your cloud servers from the command line.
You reference these sets of servers as banks.  A bank can have one or many servers.

Example: befog add web-servers --count 3

Adds 3 servers to the bank "web-servers"

Valid commands:

    configure, config   Configure a bank of servers
    add                 Provision new servers for a bank of servers
    remove, rm          De-provision servers
    start               Start servers
    stop                Stop (suspend) servers
    run                 Run a command on each of a bank of servers
    list, ls            List servers
    
You can get more options for any command with --help or -h.
eos
      exit(-1)
      
    end
  end
end
