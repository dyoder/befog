require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/help"
require "befog/commands/mixins/traceable"

module Befog
  module Commands
    
    class Add
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Help
      include Mixins::Traceable
      include Mixins::Safely
  

      command :name => :add,
        :usage => "befog add <bank> [<options>]",
        :default_to_help => true

      option :count, 
        :short => :c,
        :required => true,
        :description => "The number of machines to provision"

      option :type, 
        :short => :t,
        :description => "The type of machines to provision"

      def run        
        provision_servers(options[:count].to_i)
      end
      
      def provision_servers(count)
        error("Count must be greater than zero.") unless (count > 0)
        provisioned = []; threads = []
        count.times do |i|
          verbose <<-EOF.gsub(/^\s*/,"")
            Provision server: 
              - region: #{region}
              - type: #{flavor}
              - image: #{image}
              - security group: #{security_group}
              - keypair: #{keypair}
          EOF
          threads << Thread.new do
            safely do
              unless rehearse?
                log "Provisioning server #{i+1} for bank '#{bank_name}'..."
                server = provision_server
                server.wait_for { ready? }
                provisioned << server
                servers << server.id
              end
            end
          end
        end
        unless rehearse?
          $stdout.print "This may take a few minutes .."
          sleep 1 while threads.any? { |t| $stdout.print "."; $stdout.flush ; t.alive? } 
          $stdout.print "\n"
          provisioned.each do |server|
            log "Server #{server.id} is ready at #{server.dns_name}."
          end
          save
        end
      end
      
      def provision_server
        compute.servers.create(
            :tags => {"Name" => generate_server_name},
            :region => region, :flavor_id => flavor, :image_id => image, 
            :security_group_ids => security_group, :key_name => keypair)
      end
      
      def generate_server_name
        "#{bank_name}-#{generate_id}"
      end
      
      def generate_id
        bank["counter"] ||= 0
        bank["counter"] += 1
      end

    end
  end
end