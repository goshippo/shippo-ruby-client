#
# +Shippo+ is the ruby module enclosing all and any ruby-based
# functionality developed by Shippo, Inc.
#
# This gem providers wrappers for Shippo API in ruby. You are
# not required to use any particular library to access Shippo
# API, but it is our hope that this gem helps you bootstrap your
# Shippo integration.
#

module Shippo
end

require 'shippo/api'

# Backwards compatibility
module Shippo
  def self.api_key(value)
    ::Shippo::API.token = value
  end
  def self.api_version(value)
    ::Shippo::API.version = value
  end
  class << self
    alias_method :api_version=, :api_version
    alias_method :api_key=, :api_key
    alias_method :api_token=, :api_key
  end
end

