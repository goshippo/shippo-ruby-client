module Shippo 
  class Refund < Resource 
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
