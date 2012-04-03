require "befog/providers/aws"

module Befog
  module Commands
    module Mixins
      module Provider
        
        PROVIDERS = {
          "aws" => Befog::Providers::AWS
        }

        def providers
          configuration["providers"] ||= {}
        end
        
        def provider
          raise "You must specify a provider (with --provider or -q) to do this" unless options[:provider]
          providers[options[:provider]] ||= {}
        end
      
        def regions
          provider["regions"] ||= {}
        end

        def region
          raise "Please set the region using -r or --region." unless options[:region]
          regions[options[:region]] ||= {}
        end

        def compute(provider=nil)
          provider ||= options[:provider]
          @compute ||= PROVIDERS[provider].compute(providers[provider])
        end
      
      end
    end
  end
end

  
