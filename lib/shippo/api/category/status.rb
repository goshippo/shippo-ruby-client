require_relative 'base'
module Shippo
  module API
    module Category
      # +Status+ is a category class with the following possible values:
      #
      # * "Waiting" shipments have been successfully submitted but not yet been processed.
      # * "Queued" shipments are currently being processed.
      # * "Success" shipments have been processed successfully,
      #    meaning that rate generation has concluded.
      # * "Error" does not occur currently and is reserved for future use.
      class Status < Base
        allowed_values :waiting, :queued, :success, :error
      end
    end
  end
end
