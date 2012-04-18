# require "fog"
# require "befog/commands/mixins/command"
# require "befog/commands/mixins/configurable"
# require "befog/commands/mixins/bank"
# require "befog/commands/mixins/provider"
# require "befog/commands/mixins/server"
# require "befog/commands/mixins/help"
# 
# 
# module Befog
#   module Commands
#     
#     class Run
#   
#       include Mixins::Command
#       include Mixins::Configurable
#       include Mixins::Bank
#       include Mixins::Provider
#       include Mixins::Server
#       include Mixins::Help
# 
#       command "befog run <bank>",
#         :default_to_help => true
# 
#       option :command, 
#         :short => "-c COMMAND",
#         :long  => "--command COMMAND",
#         :required => true,
#         :description => "Command to run (required)"
#         
#       def run
#         run_for_each_server
#       end
# 
#       def run_for_server(id)
#         server = get_server(id)
#         if server.state == "running"
#           address = server.public_ip_address
#           $stdout.puts "Running command '#{options[:command]}' for #{address} ..."
#           result = Fog::SSH.new(address, "root").run(options[:command]).first
#           $stdout.puts "[#{address}: STDOUT] #{result.stdout}"
#           $stderr.puts "[#{address}: STDERR] #{result.stderr}"
#         else
#           $stdout.puts "Server #{id} isn't running - skipping"
#         end
#       end
# 
#     end
#   end
# end