module Shippo
  module Operations
    module Create
      module ClassMethods
        # Creates an item in the database
        # @param [Hash] params tacked onto the URL as URI parameters
        def create(params={})
          params.each do |k, v|
            params[k] = v[:object_id] if v.is_a?(::Shippo::API::Resource)
          end
          response = Shippo::API.request(:post, "#{self.url}/", params)
          self.from(response)
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
