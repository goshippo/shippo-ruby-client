module Shippo
  module Model
    class Address < ::Shippo::API::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create

      def validate(params={})
        response = Shippo::API.get("#{url}/validate/", params)
        Shippo::Address.from(response)
      end
    end
  end
end
