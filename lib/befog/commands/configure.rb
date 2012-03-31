require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/provider"
require "befog/commands/mixins/bank"
require "befog/commands/mixins/help"

module Befog
  
  module Commands
    
    class Configure
    
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Provider
      include Mixins::Bank
      include Mixins::Help
      
      command "befog configure [<bank>]",
        :default_to_help => true
        
      option :key, 
        :short => "-k KEY",
        :long  => "--key KEY",
        :description => "Your account key"

      option :secret, 
        :short => "-s SECRET",
        :long  => "--secret SECRET",
        :description => "Your account secret"
      
      option :provider,
        :short => "-q PROVIDER",
        :long => "--provider PROVIDER",
        :description => "The provider provisioning a bank of servers"

      option :region,
        :short => "-r REGION",
        :long => "--region REGION",
        :description => "The region (datacenter) where a bank is provisioned"

      option :image, 
        :short => "-i IMAGE",
        :long  => "--image IMAGE",
        :description => "The image for provisioning pods"
    
      option :keypair, 
        :short => "-x KEYPAIR",
        :long  => "--keypair KEYPAIR",
        :description => "The keypair name to use with SSH"

      option :group, 
        :short => "-g GROUP",
        :long  => "--group GROUP",
        :description => "The security group to use for new instances"

      def self.run(args)
        self.new(args).run
      end
      
      def initialize(arguments)
        process_arguments(arguments)
      end
      
      def run
        %w( key secret ).each do |key|
          _key = key.to_sym
          provider[key] = options[_key] if options[_key]
        end
        if options[:bank]
          %w( provider region image keypair group ).each do |key|
            _key = key.to_sym
            bank[key] = options[_key] if options[_key]
          end
        end
        save
      end
    end
  end
end