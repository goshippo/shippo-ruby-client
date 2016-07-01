require_relative 'base'
module Shippo
  module API
    module Category
      #
      # +Source+ category describes the origin of an address in the following way:
      # * +:fully_entered+ addresses only contain user-given values and are eligible for purchasing a label.
      # * +:partially_entered+ addresses lack some required information and only qualify for requesting rates.
      # * +:validator+ addresses have been created by the address validation service.
      #
      class Source < Base
        allowed_values :fully_entered, :partially_entered, :validator
      end
    end
  end
end
