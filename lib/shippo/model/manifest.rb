module Shippo
  module Model
    class Manifest < ::Shippo::API::Resource
      operations :list, :create
    end
  end
end
