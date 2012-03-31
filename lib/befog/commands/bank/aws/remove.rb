require "yaml"
require "befog/commands/mixins/help"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/aws"
require "befog/commands/mixins/server"
require "mixlib/cli"

module Befog
  module Commands
    
    module Bank
      
      module AWS
      
        class Remove
      
          include Mixlib::CLI
          include Mixins::Help
          include Mixins::Configurable
          include Mixins::Bank
          include Mixins::AWS
          include Mixins::Server

          command "befog bank aws remove",
            :default_to_help => true

          option :number, 
            :short => "-n NUMBER",
            :long  => "--number NUMBER",
            :required => true,
            :description => "The number of machines to provision"
              
          def run(args)
            name = options[:group]
            bank = banks[name]
            if bank.empty?
              $stderr.puts "No servers are in bank '#{name}'."
              return
            end
            count = options[:number].to_i
            if count <= 0
              $stderr.puts "Number must be an integer greater than 0."
              return
            end
            if count > bank.size
              $stderr.puts "Number must be less than or equal to the bank size of #{bank.size}."
              return
            end
            count.times do |i|
              id = bank.pop
              $stdout.puts "Deprovisioning server #{id} ..."
              begin
                Bank.get_server(id).destroy
              rescue => e
                $stderr.puts "Error deprovisioning server #{id}"
                bank.push id
              end
              save
            end
          end
        end
      end
    end
  end
end