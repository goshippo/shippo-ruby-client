module Shippo 
  class Customs_Item < Resource 
    @non_standard_URL = "/customs/items"
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end