module Shippo
  module Exceptions
  end
end

require 'shippo/exceptions/error'
Shippo.require_all_from('shippo/exceptions')
