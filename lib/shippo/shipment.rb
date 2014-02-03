module Shippo 
  class Shipment < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create
    def rates(params={})
      response = Shippo.request(:get, "#{url}/rates/", params)
      Shippo::Rate.construct_from(response[:results])
    end
  end
end
