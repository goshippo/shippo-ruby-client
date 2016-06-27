module Shippo
  module Model
    class Transaction < ::Shippo::API::Resource
      operations :list, :create
    end
  end
end
