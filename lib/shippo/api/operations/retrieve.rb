module Shippo
  module API
    module Operations
      module Retrieve
        # Retrieve a concrete item by its ID
        # @param [Fixnum] id Database ID of the item to be received
        # @param [String] carrier Optional carrier of the item to be received
        # @param [Hash] params Additional URI parameters tacked onto the query URL
        def get(id, carrier=nil, params={})
          carrier = "#{CGI.escape(carrier)}/" if carrier else ""
          response = Shippo::API.get("#{url}/#{carrier}#{CGI.escape(id)}/")
          self.from(response)
        end
      end
    end
  end
end
