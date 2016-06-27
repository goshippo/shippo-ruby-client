module Shippo
  module Model
    class CustomsDeclaration < ::Shippo::API::Resource
      url '/customs/declarations'
      operations :list, :create
    end
  end
end

