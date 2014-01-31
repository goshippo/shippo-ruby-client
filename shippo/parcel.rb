module Shippo 
  class Parcel < Resource 
    include Shippo::Operations::List
    include Shippo::Operations::Create
  end
end
