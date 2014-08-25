module Shippo
  class Address < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create
    def validate(params={})
      response = Shippo.request(:get, "#{url}/validate/", params)
      Shippo::Address.construct_from(response)
    end
  end
end
