module Shippo
  class Transaction < ::Shippo::API::Resource
    operations :list, :create
  end
end
