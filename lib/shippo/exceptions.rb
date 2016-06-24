module Shippo
  module Exceptions
  end
end

require 'shippo/exceptions/error'
require 'shippo/exceptions/api_error'

Shippo.require_all_from('shippo/exceptions')
