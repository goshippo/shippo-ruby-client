module Shippo
  module Model
    class CarrierAccount < ::Shippo::API::Resource
      url '/carrier_accounts'
      include Shippo::Operations::List
      include Shippo::Operations::Create
      include Shippo::Operations::Update
    end
  end
end
