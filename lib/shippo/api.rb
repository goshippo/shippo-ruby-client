require 'rest_client'
require 'json'
require 'set'

Shippo.require_all_from('shippo/api')
Shippo.require_all_from('shippo/operations')
Shippo.require_all_from('shippo/model')

require_relative 'api/request'

module Shippo
  module Api
    @base    = 'https://api.goshippo.com/v1'
    @version = 1.0
    @token   = ''

    class << self
      attr_accessor :base, :version, :token
      def request(*args)
        ::Shippo::Api::Request.new.execute(*args)
      end
    end
  end
end
