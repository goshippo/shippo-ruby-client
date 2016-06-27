module Shippo
  module Model
    class Address < ::Shippo::API::Resource
      operations :list, :create
    end
  end
end
