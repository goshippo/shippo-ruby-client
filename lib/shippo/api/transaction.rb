module Shippo
  module Model
    class Transaction < ::Shippo::API::Resource
      include Shippo::API::Operations::List
      include Shippo::API::Operations::Create
    end
  end
end
