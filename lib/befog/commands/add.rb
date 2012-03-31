require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class Add
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Bank
      include Mixins::Provider
      include Mixins::Help
  

      command "befog add <bank>",
        :default_to_help => true

      option :count, 
        :short => "-c COUNT",
        :long  => "--count COUNT",
        :required => true,
        :description => "The number of machines to provision"
        
      # TODO: Add support for machine type
    
      def run        
        count = options[:count].to_i
        if count <= 0
          $stderr.puts "Number must be an integer greater than 0."
          return
        end
        servers = []
        count.times do |i|
          $stdout.puts "Provisioning server #{i+1} ..."
          # TODO: Figure out how to give the server a name
          servers << compute.servers.create(:image_id => bank["image"], 
              :key_name => bank["keypair"], :region => bank["region"])
        end
        $stdout.puts "This may take a few minutes ..."
        servers.each do |server|
          server.wait_for { $stdout.puts "Still working ..." ; ready? }
          self.servers << server.id
        end
        servers.each do |server|
          $stdout.puts "Server #{server.id} is ready at #{server.dns_name}."
        end
        save
      end
    end
  end
end