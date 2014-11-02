module Shippo 
  class CustomsDeclaration < Resource
    @non_standard_URL = "/customs/declarations"
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
