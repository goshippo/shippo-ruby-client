module Shippo
  module Model
    class Refund < ::Shippo::Api::Resource
      include Shippo::Operations::List
      include Shippo::Operations::Create
    end
  end
end