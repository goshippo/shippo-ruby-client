module Shippo
  module API
    module Operations
      module Track
        # Retrieves tracking status of a shipment
        # @param [Fixnum] id Database ID of the shipment to be received
        # @param [String] carrier The carrier of the item to be received
        def get(id, carrier)
          response = Shippo::API.get("#{url}/#{CGI.escape(carrier)}/#{CGI.escape(id)}/")
          self.from(response)
        end
      end
    end
  end
end
