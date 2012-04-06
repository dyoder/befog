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

      option :type, 
        :short => "-t TYPE",
        :long  => "--type TYPE",
        :description => "The number of machines to provision"

      def run        
        validate_arguments
        provision_servers(count)
      end
      
      def provision_servers(count)
        servers = []
        count.times do |i|
          log "Provisioning server #{i+1} for bank '#{options[:bank]}'..."
          servers << provision_server
        end
        log "This may take a few minutes ..."
        servers.each do |server|
          Thread.new do
            server.wait_for { $stdout.putc "." ; ready? }
            self.servers << server.id
          end
        end
        servers.each do |server|
          log "Server #{server.id} is ready at #{server.dns_name}."
        end
        save
      end
      
      def provision_server
        compute.servers.create(
            :tags => {"Name" => options[:bank]}, :region => bank["region"],
            :flavor_id => bank["type"], :image_id => bank["image"], 
            :security_group_ids => [options[:group]||"default"],
            :key_name => bank["keypair"])
      end
      
      def validate_arguments
        count = options[:count].to_i
        if count <= 0
          raise CLI::Error.new "Count must be an integer greater than 0."
        end
        required options[:bank], "You must specify the bank for which you want to provision servers"
        required bank["region"], "Bank `#{options[:bank]}` doesn't have a region specified. Use `befog config #{options[:bank]} --region <region>` to configure one."
        required bank["image"], "Bank `#{options[:bank]}` doesn't have an image specified. Use `befog config #{options[:bank]} --image <image>` to configure one."
        required bank["keypair"], "Bank `#{options[:bank]}` doesn't have a keypair specified. Use `befog config #{options[:bank]} --keypair <keypair>` to configure one."
        warning bank["type"], <<-EOS
Bank `#{options[:bank]}` doesn't have an instance type specified, using default. 
Use `befog config #{options[:bank]} --type <type>` to configure one, or use the
'--type' flag with this command.
EOS
      end
    end
  end
end