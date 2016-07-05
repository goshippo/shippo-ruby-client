require 'rest_client'
require 'json'
require 'set'

require_relative '../shippo' unless defined?(Shippo) && Shippo.methods.include?(:require_all_from)

require 'shippo/exceptions'
require 'shippo/api/category'
require 'shippo/api/request'
require 'shippo/api/resource'

module Shippo
  module API
    @base    = 'https://api.goshippo.com/v1'
    @version = 1.0
    @token   = ''
    @debug   = false

    class << self
      attr_accessor :base, :version, :token, :debug
      # @param [Symbol] method One of :get, :put, :post
      # @param [String] uri the URL component after the first slash but before params
      # @param [Hash] params hash of optional parameters to add to the URL
      # @param [Hash] headers optionally added headers
      def request(method, uri, params = {}, headers = {})
        ::Shippo::API::Request.new(method:  method,
                                   uri:     uri,
                                   params:  params,
                                   headers: headers).execute
      end
      %i[get put post].each do |method|
        define_method method do |*args|
          uri, params, headers = *args
          request(method, uri, params || {}, headers || {})
        end
      end

      def debug?
        Integer(ENV['SHIPPO_API_DEBUG'] || 0) > 0
      end
      def debug_debug?
        Integer(ENV['SHIPPO_API_DEBUG'] || 0) > 1
      end
    end
  end
end

Shippo.require_all_from('shippo/api')
Shippo.require_all_from('shippo/model')

