module Shippo 
  class CustomsItem < Resource
    @non_standard_URL = "/customs/items"
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
