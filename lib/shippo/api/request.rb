require 'rest_client'
require 'socket'
require 'json'
require 'set'

require 'shippo/exceptions'

module Shippo
  module API
    #
    # This class is the primary Interface to the Shippo API.
    # +Request+ is created to execute a single given call to an API,
    # and once executed, it stores +response+ object.  Used requests can not
    # be re-executed.
    #
    # == Example
    #
    #   @request = Shippo::API::Request.new(
    #            method: :get,
    #               uri: '/address,
    #            params: { object_id: 1 },
    #           headers: { 'Last-Modified' => '1213145' }
    #   begin
    #     @response = @request.execute
    #     Shippo::Model::Address.from(@response)
    #   # =>
    #
    class Request
      attr_accessor :username, :password
      attr_accessor :method, :url, :params, :headers

      # Result of the execute method is stored in #response and #parsed_response
      attr_accessor :response, :parsed_response

      # @param [symbol] method :get or any other method such as :put, :post, etc.
      # @param [String] uri URI component appended to the base URL
      # @param [Hash] params parameters to append to the URL
      # @param [Hash] headers headers hash sent to the server
      def initialize(method:, uri:, params: {}, headers: {})
        self.method   = method
        self.params   = params
        self.headers  = headers
        self.url      = api_url(uri)
        self.response = nil
      end

      def execute
        raise ArgumentError.new('Response is already defined, create another Request object.') if self.response
        validate!
        begin
          self.response        = shippo_phone_home
          self.parsed_response = JSON::parse(response.body, { symbolize_names: true })

        rescue ::RestClient::Unauthorized => e
          raise Shippo::Exceptions::AuthenticationError.new(e.message)

        rescue ::RestClient::Exception => e
          raise Shippo::Exceptions::ConnectionError.new(connection_error_message(url, e))

        rescue ::JSON::JSONError, ::JSON::ParserError
          raise Shippo::Exceptions::APIServerError.new('Unable to read data received back from the server', self)

        rescue StandardError => e
          raise Shippo::Exceptions::ConnectionError.new(connection_error_message(url, e)) if e.message =~ /TCP|connection|getaddrinfo/

          STDERR.puts "#{self.class.name}: Internal error occurred while connecting to #{url}: #{e.message}".bold.red
          STDERR.puts 'Stack Trace'.bold.yellow.underlined
          STDERR.puts e.backtrace.join("\n").yellow
          raise Shippo::Exceptions::Error.new(e)
        end
        self.parsed_response
      end

      private

      def shippo_phone_home
        payload = {}
        request_url = url
        (method == :get) ? request_url = params_to_url(params, url) : payload = params.to_json
        setup_headers!(headers)
        opts = make_opts!(headers, method, payload, request_url)
        make_request!(opts)
      end

      def make_request!(opts)
        RestClient::Request.execute(opts) { |response, request, result, &block|
          if [301, 302, 307].include? response.code
            response.follow_redirection(request, result, &block)
          else
            response.return!(request, result, &block)
          end
        }
      end

      def make_opts!(headers, method, payload, url)
        { :headers      => headers,
          :method       => method,
          :payload      => payload,
          :url          => url,
          :open_timeout => 15,
          :timeout      => 30,
          :user         => username,
          :password     => password,
          :user_agent   => 'Shippo/v2.0 RubyBindings'
        }
      end

      def setup_headers!(headers)
        headers.merge!(
          :accept        => :json,
          :content_type  => :json,
          :Authorization => "ShippoToken #{token}"
        )
      end

      def base
        ::Shippo::API.base
      end

      def token
        ::Shippo::API.token
      end

      def connection_error_message(url, error)
%Q[Could not connect to the Shippo API, via URL
  #{url}.

Please check your Internet connection, try again, if the problem
persists please contact Shippo Customer Support.

Error Description:
  #{error.class.name} ⇨ #{error.message}].gsub(/^\s*/, '')
      end

      def api_url(uri_component = '')
        base + uri_component
      end

      def params_to_url(params, url)
        pairs = []
        params.each { |k, v|
          pairs.push "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
        }
        url += "?#{pairs.join('&')}" unless pairs.empty?
        url
      end

      def validate!
        raise Shippo::Exceptions::AuthenticationError.new(
          'API credentials seems to be missing, perhaps you forgot to set Shippo::API.token?') \
          unless token
      end
    end
  end
end
