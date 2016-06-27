module Shippo
  module API
    module Operations
      module Validate
        def validate(params={})
          response = Shippo::API.get("#{url}/validate/", params)
          Shippo::Address.from(response)
        end
      end
    end
  end
end
