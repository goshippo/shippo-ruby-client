module Shippo
  module API
    module Operations
      module Validate
        def validate(object_id, params={})
          response = Shippo::API.get("#{url}/#{CGI.escape(object_id)}/validate/", params)
          Shippo::Address.from(response)
        end
      end
    end
  end
end
