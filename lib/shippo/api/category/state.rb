require_relative 'base'
module Shippo
  module API
    module Category
      # "VALID" shipments contain all required values and can be used to get rates and purchase labels.
      # "INCOMPLETE" shipments lack required values but can be used for getting rates.
      # "INVALID" shipments can't be used for getting rates or labels.
      class State < Base
        allowed_values :valid, :invalid, :incomplete
      end
    end
  end
end
