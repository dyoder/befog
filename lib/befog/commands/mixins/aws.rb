require "fog"
Excon.defaults[:ssl_verify_peer] = false

module Befog
  module Commands
    module Mixins
      module AWS

        def self.included(target)
          
          def target.run(args) ; self.new(args).run ; end

          target.module_eval do
            
            include Mixins::CLI
        
            option :region,
              :short => "-r REGION",
              :long => "--region REGION",
              :description => "The region (datacenter) for region-specific options"

          end
        end


        def aws
          configuration["aws"] ||= {}
        end
      
        def regions
          aws["regions"] ||= {}
        end

        def region
          raise "Please set the region using -r or --region." unless options[:region]
          regions[options[:region]] ||= {}
        end

        def provider
          @provider ||= Fog::Compute.new(:provider => "AWS", 
            :aws_access_key_id => aws["key"], 
            :aws_secret_access_key => aws["secret"])
        end
      
      end
    end
  end
end

  
