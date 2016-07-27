module Shippo
  class CarrierAccount < ::Shippo::API::Resource
    operations :list, :create, :update
  end
end
