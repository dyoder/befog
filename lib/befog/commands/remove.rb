require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/server"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class Remove
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Bank
      include Mixins::Provider
      include Mixins::Server
      include Mixins::Help

      command "befog remove <bank>",
        :default_to_help => true

      option :count, 
        :short => "-c COUNT",
        :long  => "--count COUNT",
        :required => true,
        :description => "The number of machines to de-provision"

      def run
        if servers.empty?
          $stderr.puts "No servers are in bank '#{name}'."
          return
        end
        count = options[:count].to_i
        if count <= 0
          $stderr.puts "Number must be an integer greater than 0."
          return
        end
        if count > servers.size
          $stderr.puts "Number must be less than or equal to the bank size of #{bank.size}."
          return
        end
        count.times do |i|
          id = servers.pop
          $stdout.puts "Deprovisioning server #{id} ..."
          begin
            get_server(id).destroy
          rescue => e
            $stderr.puts "Error deprovisioning server #{id}"
            servers.push id
          end
          save
        end
      end
    end
  end
end