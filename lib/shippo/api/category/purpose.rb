require_relative 'base'
module Shippo
  module API
    module Category
      # Indicates whether a shipment can be used to purchase Labels or only to obtain quote Rates.
      # Note that if at least one quote Address is passed in the original request,
      # the Shipment will be eligible for quotes only.
      class Purpose < Base
        allowed_values :purchase, :quote
      end
    end
  end
end
