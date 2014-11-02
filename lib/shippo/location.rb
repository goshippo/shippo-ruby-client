module Shippo
  class Location < Resource
    def address
      if self[:address].is_a?(Hash)
        Shippo::Address.construct_from(self[:address])
      else
        self[:address]
      end
    end
  end
end
