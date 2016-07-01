module Shippo
  module Model
    class CustomsItem < ::Shippo::API::Resource
      operations :list, :create
    end
  end
end
