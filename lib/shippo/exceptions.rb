require 'shippo/exceptions/error'
require 'shippo/exceptions/api_error'
require 'shippo/exceptions/api_server_error'

class Shippo::Exceptions::ConnectionError < Shippo::Exceptions::Error; end
class Shippo::Exceptions::AuthenticationError < Shippo::Exceptions::Error; end
class Shippo::Exceptions::MissingDataError < Shippo::Exceptions::Error; end
class Shippo::Exceptions::AbstractClassInitError < Shippo::Exceptions::Error; end
