module Shippo
  module Model
    class Shipment < ::Shippo::API::Resource
      operations :list, :create, :rates
    end
  end
end
