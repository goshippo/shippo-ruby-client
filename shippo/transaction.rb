module Shippo 
  class Transaction < Resource
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
