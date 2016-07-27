module Shippo
  class Shipment < ::Shippo::API::Resource
    operations :list, :create, :rates
  end
end
