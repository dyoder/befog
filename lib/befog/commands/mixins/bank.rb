module Befog
  module Commands
    module Mixins
      module Bank
        
        def banks
          configuration["banks"] ||= {}
        end
        
        def _bank
          raise "You must specify a bank to do this" unless options[:bank]
          banks[options[:bank]] ||= {}
        end
        
        def bank
          _bank["configuration"] ||= {}
        end
        
        def servers
          _bank["servers"] ||= []
        end
        
        def process_arguments(arguments)
          _bank,*rest = arguments
          if _bank =~ /^\-/
            super
          else
            super(rest)
            options[:bank] = _bank
            bank.each do |key,value|
              options[key.to_sym] = value
            end
          end
        end
        
        def run_for_each_server
          if servers.empty?
            $stderr.puts "No servers are in bank '#{options[:bank]}'."
            return
          end
          servers.each do |id|
            run_for_server(id)
          end
        end
      
      end
    end
  end
end
    