require "fog"
Excon.defaults[:ssl_verify_peer] = false

module Befog
  
  module Providers
    
    class AWS
      
      def self.compute(configuration)
        Fog::Compute.new(:provider => "AWS", 
          :aws_access_key_id => configuration["key"], 
          :aws_secret_access_key => configuration["secret"])
      end
      
    end
    
  end
  
end