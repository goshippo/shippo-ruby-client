module Shippo
  module Model
    class CustomsDeclaration < ::Shippo::API::Resource
      url '/customs/declarations'
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end

