module Shippo 
  class CarrierAccount < Resource 
    @non_standard_URL = "/carrier_accounts"
    include Shippo::Operations::List
    include Shippo::Operations::Create
    include Shippo::Operations::Update
  end
end
