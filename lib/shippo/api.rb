require 'rest_client'
require 'json'
require 'set'

require_relative '../shippo' unless defined?(Shippo) && Shippo.respond_to?(:dir_r)

require 'shippo/exceptions'
require 'shippo/api/category'
require 'shippo/api/request'
require 'shippo/api/resource'

module Shippo
  module API
    @base     = 'https://api.goshippo.com/v1'
    @version  = 1.0
    @token    = ''
    @debug    = Integer(ENV['SHIPPO_DEBUG'] || 0) > 0 ? true : false
    @warnings = true

    class << self
      attr_accessor :base, :version, :token, :debug, :warnings
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
        Shippo::API.debug
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/api/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/api/transformers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/api/extend/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/model/*.rb'].each {|file| require file }