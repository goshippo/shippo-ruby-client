module Shippo
  module API
    module Operations
      module Create
        # Creates an item in the database
        # @param [Hash] params tacked onto the URL as URI parameters
        def create(params={})
          params.dup.each do |k, v|
            params[k] = v[:object_id] if v.is_a?(::Shippo::API::Resource)
          end
          response = Shippo::API.post("#{url}/", params)
          self.from(response)
        end
      end
    end
  end
end
