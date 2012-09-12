require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/help"

module Befog
  
  module Commands
    
    class Configure
    
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Safely
      include Mixins::Help
      
      command :name => :configure,
        :usage => "befog configure [<bank>] [<options>]",
        :default_to_help => true
        
      option :key, 
        :short => :k,
        :description => "Your account key"

      option :secret, 
        :short => :s,
        :description => "Your account secret"
      
      option :provider,
        :short => :q,
        :description => "The provider provisioning a bank of servers"

      option :region,
        :short => :r,
        :description => "The region (datacenter) where a bank is provisioned"

      option :image, 
        :short => :i,
        :description => "The image for provisioning pods"
    
      option :keypair, 
        :short => :x,
        :description => "The cloud provider SSH key pair name to use with the instances in this bank"

      option :group, 
        :short => :g,
        :description => "The security group to use for new instances"
    
      option :type, 
        :short => :t,
        :description => "The number of machines to provision"

      def run
        safely do
          %w( key secret ).each do |key|
            _key = key.to_sym
            provider[key] = options[_key] if options[_key]
          end
          %w( region image keypair group type ).each do |key|
            _key = key.to_sym
            bank[key] = options[_key] if options[_key]
          end          
          if options[:bank] and options[:provider]
            bank["provider"] = options[:provider]
          end
          save
        end
      end
    end
  end
end
