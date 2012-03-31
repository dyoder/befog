module Befog
  module Commands
    module Mixins
      module AWS

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
            :aws_access_key_id => Configure::AWS["key"], 
            :aws_secret_access_key => Configure::AWS["secret"])
        end
      
      end
    end
  end
end

  
