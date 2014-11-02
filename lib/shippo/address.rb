module Shippo
  class Address < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create

    def validate(params={})
      response = Shippo.request(:get, "#{url}/validate/", params)
      Shippo::Address.construct_from(response)
    end

    def locations(params = {}, options = {})
      options = {
        sync: true
      }.merge(options)

      locations_url = "#{url}/locations/"
      locations_url << 'sync/' if options[:sync]

      response = Shippo.request(:get, locations_url, params)
      Shippo::Location.construct_from(response[:results])
    end
  end
end
