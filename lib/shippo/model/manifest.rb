module Shippo
  module Model
    class Manifest < ::Shippo::Api::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end
