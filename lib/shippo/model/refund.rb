module Shippo
  module Model
    class Refund < ::Shippo::API::Resource
      operations :list, :create
    end
  end
end
