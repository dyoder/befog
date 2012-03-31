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
      
        class Add
      
          include Mixins::CLI
          include Mixins::Help
          include Mixins::Configurable
          include Mixins::Bank
          include Mixins::AWS
          include Mixins::Server

          command "befog bank aws add",
            :default_to_help => true

          option :number, 
            :short => "-n NUMBER",
            :long  => "--number NUMBER",
            :required => true,
            :description => "The number of machines to provision"
        
          option :type, 
            :short => "-t TYPE",
            :long  => "--type TYPE",
            :required => true,
            :description => "The type of machines to provision"

          def run        
            count = options[:number].to_i
            if count <= 0
              $stderr.puts "Number must be an integer greater than 0."
              return
            end
            count.times do |i|
              $stdout.puts "Provisioning server #{i+1} ..."
              # TODO: Figure out how to give the server a name
              servers << provider.servers.create(:image_id => region["image"], 
                  :key_name => region["keypair"], :region => options[:region])
            end
            $stdout.puts "This may take a few minutes ..."
            servers.each do |server|
              server.wait_for { $stdout.puts "Still working ..." ; ready? }
            end
            servers.each do |server|
              $stdout.puts "Server #{server.id} is ready at #{server.dns_name}."
            end
            bank[name] += servers.map { |s| s.id }
            save
          end
        end
      end
    end
  end
end