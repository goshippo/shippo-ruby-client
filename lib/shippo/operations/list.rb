module Shippo
  module Operations
    module List
      module ClassMethods
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
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
