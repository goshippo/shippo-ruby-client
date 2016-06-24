module Shippo
  module Model
    class CustomsItem < ::Shippo::API::Resource
      url '/customs/items'
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end
