require "befog/commands/mixins/command"
require "befog/commands/mixins/configurable"
require "befog/commands/mixins/scope"
require "befog/commands/mixins/safely"
require "befog/commands/mixins/selectable"
require "befog/commands/mixins/help"

module Befog
  module Commands
    
    class Remove
  
      include Mixins::Command
      include Mixins::Configurable
      include Mixins::Scope
      include Mixins::Safely
      include Mixins::Selectable
      include Mixins::Help

      command :name => :remove,
        :usage => "befog remove [<bank>] <options>",
        :default_to_help => true

      option :count, 
        :short => :c,
        :description => "The number of machines to de-provision"
        
      option :all,
        :short => :a,
        :description => "Deprovision all selected servers"
        

      def run
        count = 0 ; threads = [] ; deleted = []
        unless options[:all]
          count = options[:count].to_i
          if count <= 0
            error "Count must be an integer greater than 0."
          end
        end
        run_for_selected do |id|
          if options[:all] or count > 0
            # threads << Thread.new do
              safely do
                log "Deprovisioning server #{id} ..."
                compute.servers.get(id).destroy
                deleted << id
                count -= 1
              end
            # end
          end
        end
        $stdout.print "This may take a few minutes .."
        # sleep 1 while threads.any? { |t| $stdout.print "."; $stdout.flush ; t.alive? } 
        $stdout.print "\n"
        self.servers -= deleted
        save
      end
      
    end
  end
end