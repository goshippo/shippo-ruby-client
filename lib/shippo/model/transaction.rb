module Shippo
  module Model
    class Transaction < ::Shippo::Api::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end
