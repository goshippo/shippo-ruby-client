module Shippo
  class Order < ::Shippo::API::Resource
    operations :list, :create
  end
end
