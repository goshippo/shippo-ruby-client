module Shippo
  module API
    module Operations
      module List
        # Return all items
        # @param [Hash] params of additional URI parameters tacked onto the query URL
        def all(params={})
          response = Shippo::API.get("#{url}/", params)
          self.from(response)
        end

        # Retrieve a concrete item by it's ID
        # @param [Fixnum] id database ID of the item to be retrieved
        # @param [Hash] params of additional URI parameters tacked onto the query URL
        def get(id, params={})
          response = Shippo::API.get("#{url}/#{CGI.escape(id)}/", params)
          self.from(response)
        end

        # Retrieve a concrete item by its ID and carrier
        # @param [Fixnum] id Database ID of the item to be received
        # @param [String] carrier The carrier of the item to be received
        # @param [Hash] params Additional URI parameters tacked onto the query URL
        def get_with_carrier(id, carrier, params={})
          response = Shippo::API.get("#{url}/#{CGI.escape(carrier)}/#{CGI.escape(id)}/")
          self.from(response)
        end
      end
    end
  end
end
