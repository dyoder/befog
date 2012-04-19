require 'fog'

module Befog
  module Commands
    module Mixins
      module Scope
        
        def provider_name
          options[:provider] or bank["provider"] or 
            error("Specify a provider with --provider or by adding one to the '#{bank_name}' bank.")
        end
        
        def provider?
          !!options[:provider] or bank["provider"]
        end
        
        def providers
          @providers ||= configuration["providers"]
        end
        
        def provider
          @provider ||= providers[provider_name]
        end
        
        def account_key
          provider["key"]
        end
        
        def account_secret
          provider["secret"]
        end
        
        # TODO: do something clever once we have more than 2-3 providers
        def compute
          case provider_name
          when "aws"
            @compute ||= Fog::Compute.new(:provider => "AWS", 
              :aws_access_key_id => account_key, 
              :aws_secret_access_key => account_secret,
              :region => region)
          else
            error("Provider '#{provider_name}' is currently unsupported.")
          end
        end
        
        def region
          options[:region] or bank["region"] or 
            error("Specify a region with --region or by adding one to the '#{bank_name}' bank.")
        end
        
        def region?
          !!options[:region] or bank["region"]
        end
        
        def flavor
          options[:type] or bank["type"] or 
            error("Specify an instance type (flavor) with --type or by adding one to the '#{bank_name}' bank.")
        end
        
        def flavor?
          !!options[:type] or bank["type"]
        end
        
        def image
          options[:image] or bank["image"] or 
            error("Specify an image with --image or by adding one to the '#{bank_name}' bank.")
        end
        
        def image?
          !!options[:image] or bank["image"]
        end
        
        def security_group
          options[:group] or bank["group"] or 
            error("Specify a security group with --group or by adding one to the '#{bank_name}' bank.")
        end
        
        def security_group?
          options[:group] or bank["group"]
        end
        
        def keypair
          options[:keypair] or bank["keypair"] or 
            error("Specify a keypair with --keypair or by adding one to the '#{bank_name}' bank.")
        end
        
        def keypair?
          !!options[:keypair] or bank["keypair"]
        end
        
        def banks
          configuration["banks"] ||= {}
        end
        
        def _bank
          banks[bank_name] ||= {}
        end
        
        def bank
          _bank["configuration"] ||= {}
        end
        
        def bank?
          !!options[:bank]
        end
        
        def bank_name
          options[:bank] or error("Did you mean to include a bank name?")
        end
        
        def servers
          _bank["servers"] ||= []
        end
        
        def servers=(array)
          _bank["servers"] = array
        end
        
      end
    end
  end
end