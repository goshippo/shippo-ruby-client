module Shippo
  module Model
    class Address < ::Shippo::Api::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create

      def validate(params={})
        response = Shippo::Api.request(:get, "#{url}/validate/", params)
        Shippo::Address.construct_from(response)
      end
    end
  end
end
