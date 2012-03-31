module Befog
  module Commands
    module Mixins
      module Bank
        
        def self.included(target)
          
          def target.run(args) ; self.new(args).run ; end

          target.module_eval do
            
            include Mixins::CLI
        
            option :bank, 
              :short => "-b BANK",
              :long  => "--bank BANK",
              :required => true,
              :description => "Bank of servers on which to operate"
          end
        end
        
        attr_reader :options
        
        def initialize(arguments)
          @options = self.class.process_arguments(arguments)
        end

        def banks
          configuration["banks"] ||= {}
        end
        
        def run
          name = options[:group]
          bank = (banks[name]||=[])
          if bank.empty?
            $stderr.puts "No servers are in bank '#{name}'."
            return
          end
          bank.each do |id|
            run_for_server(id)
          end
        end
      
      end
    end
  end
end
    