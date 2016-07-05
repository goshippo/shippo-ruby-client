module Shippo
  module Model
    class CarrierAccount < ::Shippo::API::Resource
      operations :list, :create, :update
    end
  end
end
