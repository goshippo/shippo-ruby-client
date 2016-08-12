module Shippo
  class CarrierAccount < ::Shippo::API::Resource
    operations :list, :create, :update
    url '/carrier_accounts'
  end
end
