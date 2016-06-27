require 'shippo/api/resource'
module Shippo
  module Model
    class Parcel < ::Shippo::API::Resource
      operations :list, :create
    end
  end
end
