module Shippo
  module API
    module Operations
      module Batch
        # Retrieves a Batch by its ID
        # @param [String] id The ID of the Batch object
        # @param [Hash] params Optional params tacked onto the URL as URI parameters
        def get(id, params={})
          response = Shippo::API.get("#{url}/#{CGI.escape(id)}", params)
          self.from(response)
        end

        # Adds a new shipment to a batch object
        # @param [String] id The ID of the Batch object
        # @param [Array] shipments Array of shipment objects to be added
        def add_shipment(id, shipments=[])
          response = Shippo::API.post("#{url}/#{CGI.escape(id)}/add_shipments", shipments)
          self.from(response)
        end

        # Removes an existing shipment from a batch object
        # @param [String] id The ID of the Batch object
        # @param [Array] shipment_ids Array of shipment IDs to be removed
        def remove_shipment(id, shipment_ids=[])
          response = Shippo::API.post("#{url}/#{CGI.escape(id)}/remove_shipments", shipment_ids)
          self.from(response)
        end

        # Purchases an existing batch
        # @param [String] id The ID of the Batch object
        def purchase(id)
          response = Shippo::API.post("#{url}/#{CGI.escape(id)}/purchase")
          self.from(response)
        end
      end
    end
  end
end
