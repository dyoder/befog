module Befog
  module Commands
    module Mixins
      module Server

        def get_server(id)
          compute.servers.get(id)
        end

      end
    end
  end
end