module Shippo
  module API
    module Operations
      module Rates
        def rates(shipment_object_id, currency = nil, params = {})
          if !currency.nil?
            response = Shippo::API.get("#{url}/#{shipment_object_id}/rates/#{currency}/", params)
          else
            response = Shippo::API.get("#{url}/#{shipment_object_id}/rates/", params)
          end
          Shippo::Rate.from(response[:results])
        end
      end
    end
  end
end
