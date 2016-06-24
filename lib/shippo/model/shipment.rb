module Shippo
  module Model
    class Shipment < ::Shippo::API::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create

      def rates(currency=nil, params={})
        if !currency.nil?
          response = Shippo::API.request(:get, "#{url}/rates/#{currency}/", params)
        else
          response = Shippo::API.request(:get, "#{url}/rates/", params)
        end
        Shippo::Rate.from(response[:results])
      end
    end
  end
end
