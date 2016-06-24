module Shippo
  module Model
    class Shipment < ::Shippo::Api::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create

      def rates(currency=nil, params={})
        if !currency.nil?
          response = Shippo::Api.request(:get, "#{url}/rates/#{currency}/", params)
        else
          response = Shippo::Api.request(:get, "#{url}/rates/", params)
        end
        Shippo::Rate.construct_from(response[:results])
      end
    end
  end
end
