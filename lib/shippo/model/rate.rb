module Shippo
  module Model
    class Rate < ::Shippo::API::Resource
      include Shippo::Operations::List
    end
  end
end
