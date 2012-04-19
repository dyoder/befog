module Befog
  module Commands
    module Mixins
      module Safely
        
        def safely
          begin
            yield
          rescue Befog::CLI::Error => e
            $stderr.puts "befog #{command.name}: #{e.message}"
            exit(-1)
          rescue => e # uh-oh
            $stderr.puts "Unexpected error"
            $stderr.puts "#{e.class}: #{e.message}"
            $stderr.puts e.backtrace
            exit(-1)
          end
        end


      end
    end
  end
end
            



