require "fog"
require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/server"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class List
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Bank
      include Mixins::Provider
      include Mixins::Server
      include Mixins::Help

      command "befog list [<bank>]",
        :default_to_help => false

      option :provider,
        :short => "-q PROVIDER",
        :long => "--provider PROVIDER",
        :description => "The provider provisioning a bank of servers"


      def run
        if options[:bank]
          list_bank(options[:bank])
        elsif options[:provider]
          list_provider(options[:provider])
        else
          list_all
        end
      end
      
      def list_all
        $stdout.puts "All Servers"
        banks.keys.select do |name|
          list_bank(name)
        end
      end
      
      def list_provider(provider,indent="")
        $stdout.puts "#{indent}- Provider: #{provider}"
        indent += "  "
        banks.select do |name,b|
          if b["configuration"] and b["configuration"]["provider"] == provider
            list_bank(name,indent)
          end
        end
      end
      
      def list_bank(name, indent="")
        out = []
        out << "#{indent}- Bank: #{name}"
        indent += "  "
        configuration = banks[name]["configuration"]
        out += %w( provider region image keypair type ).reduce([]) do |rval,key|        
          rval << "#{key}: #{configuration[key]}" unless configuration[key].nil?
          rval
        end
        out << "instances:"
        banks[name]["servers"].each do |id|
          c = compute(configuration["provider"])
          s = c.servers.get(id)
          out << "- '#{s.tags["Name"]}' #{s.public_ip_address} (#{s.state})"
        end
        $stdout.puts out.join("\n#{indent}")
      end

    end
  end
end