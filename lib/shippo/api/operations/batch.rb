module Shippo
  module API
    module Operations
      module Batch
        # Adds a new shipment to a batch object
        # @param [Hash] params tacked onto the URL as URI parameters
        def add_shipment(id, shipments=[])
          response = Shippo::API.post("#{url}/#{CGI.escape(id)}/add_shipments", shipments)
          self.from(response)
        end
      end
    end
  end
end
