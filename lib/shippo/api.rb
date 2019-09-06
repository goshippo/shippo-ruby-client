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
    @base         = 'https://api.goshippo.com'
    @version      = ''
    @token        = ''
    @debug        = Integer(ENV['SHIPPO_DEBUG'] || 0) > 0 ? true : false
    @warnings     = true
    @open_timeout = 15
    @read_timeout = 30

    class << self
      attr_writer :token
      attr_accessor :base, :version, :debug, :warnings, :open_timeout, :read_timeout

      def token
        Thread.current[:shippo_api_token] || @token
      end

      def with_token(token)
        old_thread_token = Thread.current[:shippo_api_token]
        Thread.current[:shippo_api_token] = token
        yield
      ensure
        Thread.current[:shippo_api_token] = old_thread_token
      end

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
          self.request(method, uri, params || {}, headers || {})
        end
      end

      def debug?
        self.debug
      end
    end
  end
end

Dir[File.dirname(__FILE__) + '/api/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/api/transformers/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/api/extend/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/model/*.rb'].each {|file| require file }
