require 'rest_client'
require 'set'
require './shippo/container_object.rb'
require './shippo/api_object.rb'
require './shippo/operations/list.rb'
require './shippo/operations/create.rb'
require './shippo/resource.rb'
require './shippo/address.rb'
require './shippo/parcel.rb'
require './shippo/shipment.rb'
require './shippo/transaction.rb'
require './shippo/rate.rb'

module Shippo
  @api_base = 'https://tobias.schottdorf%40gmail.com:qPkabv42hJAs@api.goshippo.com/v1'

  class << self
    attr_accessor :api_base, :api_version
  end

  def self.api_url(url='')
    @api_base + url
  end

  def self.request(method, url, params = {}, headers = {})
    # authenticationerror, see how to best pass credentials
   begin
     payload = params
     url = api_url(url)
     opts = { :headers => headers,
       :method => method,
       :payload => payload,
       :url => url,
       :open_timeout => 15,
       :timeout => 30
     }
     res = RestClient::Request.execute(opts)
   rescue => e
     # rescue restclient errors here, turn into apiConnError
     puts "Something wrong"
     p e
     p opts
   end
   parse(res)
  end
  def self.parse(response)
    JSON::parse(response.body, { :symbolize_names => true })
  end
end

