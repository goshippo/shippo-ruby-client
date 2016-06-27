module Shippo
  module Model
    class CustomsItem < ::Shippo::API::Resource
      url '/customs/items'
      operations :list, :create
    end
  end
end
