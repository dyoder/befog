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
      
      class Add
      
        include Mixins::CLI
        include Mixins::Help
        include Mixins::Configurable
        include Mixins::Bank
        include Mixins::AWS
        include Mixins::Server

        option :bank, 
          :short => "-b BANK",
          :long  => "--bank BANK",
          :required => true,
          :description => "Bank to which to add a server"

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

        option :region,
          :short => "-r REGION",
          :long => "--region REGION",
          :required => true,
          :description => "The region (datacenter) where the machines will be provisioned"
              
        def run        
          name = options[:group]
          servers = []
          count = options[:number].to_i
          if count <= 0
            $stderr.puts "Number must be an integer greater than 0."
            return
          end
          count.times do |i|
            $stdout.puts "Provisioning server #{i+1} ..."
            servers << provider.servers.create(:image_id => aws["image"], 
                :key_name => region["keypair"], :region => options[:region],
                :tags => {"name" => name})
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