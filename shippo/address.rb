module Shippo 
  class Address < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
