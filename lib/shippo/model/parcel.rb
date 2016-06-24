require 'shippo/api/resource'
module Shippo
  module Model
    class Parcel < ::Shippo::API::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end
