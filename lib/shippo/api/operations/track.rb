module Shippo
  module API
    module Operations
      module Track
        # Retrieve a concrete item by it's ID
        # @param [Fixnum] id database ID of the item to be retrieved
        # @param [Hash] params of additional URI parameters tacked onto the query URL
        def get(carrier, tracking_number)
          response = Shippo::API.get("#{url}/#{carrier}/#{CGI.escape(tracking_number)}/")
          self.from(response)
        end
      end
    end
  end
end
