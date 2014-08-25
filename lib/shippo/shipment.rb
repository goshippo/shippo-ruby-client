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
  end
end
