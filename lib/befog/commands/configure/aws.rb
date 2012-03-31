require "yaml"
require "befog/commands/mixins/help"
require "befog/commands/mixins/cli"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/aws"

module Befog
  
  module Commands
    
    module Configure
    
      class AWS
      
        include Mixins::Help
        include Mixins::CLI
        include Mixins::Configurable
        include Mixins::AWS
        
        command "befog configure aws",
          :default_to_help => true
          
        option :key, 
          :short => "-k KEY",
          :long  => "--key KEY",
          :description => "Your AWS account key"

        option :secret, 
          :short => "-s SECRET",
          :long  => "--secret SECRET",
          :description => "Your AWS account secret"
        
        option :image, 
          :short => "-i IMAGE",
          :long  => "--image IMAGE",
          :description => "The AWS image for provisioning pods"
      
        option :keypair, 
          :short => "-x KEYPAIR",
          :long  => "--keypair KEYPAIR",
          :description => "The AWS keypair name to use with SSH"

        option :group, 
          :short => "-g GROUP",
          :long  => "--group GROUP",
          :description => "The AWS security group to use for new instances"

        option :region,
          :short => "-r REGION",
          :long => "--region REGION",
          :description => "The region (datacenter) for region-specific options"

        def self.run(args)
          self.new(args).run
        end
        
        attr_reader :options
        
        def initialize(arguments)
          @options = self.class.process_arguments(arguments)
        end
        
        def run
          %w( key secret ).each do |key|
            _key = key.to_sym
            aws[key] = options[_key] if options[_key]
          end
          %w( image keypair group ).each do |key|
            _key = key.to_sym
            region[key] = options[_key] if options[_key]
          end
          save
        end
      end
    end
  end
end