module Shippo
  class Address < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create

    def validate(params={})
      response = Shippo.request(:get, "#{url}/validate/", params)
      Shippo::Address.construct_from(response)
    end

    def locations(params = {}, sync = true)
      locations_url = "#{url}/locations/"
      locations_url << 'sync/' if sync

      response = Shippo.request(:get, locations_url)
      Shippo::Location.construct_from(response[:results])
    end
  end
end
