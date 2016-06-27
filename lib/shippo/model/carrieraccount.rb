module Shippo
  module Model
    class CarrierAccount < ::Shippo::API::Resource
      url '/carrier_accounts'
      operations :list, :create, :update
    end
  end
end
