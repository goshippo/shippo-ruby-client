module Shippo
  module Model
    class Manifest < ::Shippo::API::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end
