module Shippo 
  class Shipment < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create

    def rates(currency=nil, params={})
      if !currency.nil?
        response = Shippo.request(:get, "#{url}/rates/#{currency}/", params)
      else
        response = Shippo.request(:get, "#{url}/rates/", params)
      end
      Shippo::Rate.construct_from(response[:results])
    end

    def lowest_rate(provider = nil, currency = nil, params = {})
      records = rates(currency, params)
      records = records.select { |r| r.provider == provider } if provider
      records.min_by { |r| r.amount.to_f }
    end
  end
end
