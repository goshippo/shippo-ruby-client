module Shippo
  module API
    module Operations
      module Rates
        def rates(currency = nil, params = {})
          if !currency.nil?
            response = Shippo::API.get("#{url}/rates/#{currency}/", params)
          else
            response = Shippo::API.get("#{url}/rates/", params)
          end
          Shippo::Rate.from(response[:results])
        end
      end
    end
  end
end
