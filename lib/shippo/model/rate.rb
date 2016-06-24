module Shippo
  module Model
    class Rate < ::Shippo::Api::Resource
      include Shippo::Operations::List
    end
  end
end
