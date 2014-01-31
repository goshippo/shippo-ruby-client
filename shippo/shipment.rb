module Shippo 
  class Shipment < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
