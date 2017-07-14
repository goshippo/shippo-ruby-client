require 'rest_client'
require 'socket'
require 'json'
require 'set'
require 'awesome_print'

require 'shippo/exceptions'

module Shippo
  module API
    #
    # This class is the primary *internal* Interface to the Shippo API.
    #
    # Public consumers should use Model API, and perform actions on models
    # rather than submit requests directly using this class.
    #
    # +Request+ instance is created with the intention to execute a single
    # API call and once executed, it stores +response+ object.  Used
    # requests can not be re-executed.
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
    #     Shippo::Address.from(@response)
    #   # =>
    #
    class Request
      attr_accessor :username, :password
      attr_accessor :method, :url, :params, :headers

      # Result of the execute method is stored in #response and #parsed_response
      attr_accessor :response, :parsed_response, :redirection_history

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

        rescue ::RestClient::BadRequest => e
          if e.respond_to?(:response) && e.response.is_a?(RestClient::Response)
            awesome_print_response(e) if Shippo::API.debug?
            raise Shippo::Exceptions::APIServerError.new('Backend responded with an error',
                                                         self, e.response, e.message)
          end

        rescue ::JSON::JSONError, ::JSON::ParserError => e
          raise Shippo::Exceptions::InvalidJsonError.new(e.message)

        rescue ::RestClient::BadRequest => e
          raise Shippo::Exceptions::InvalidInputError.new(e.inspect)

        rescue ::RestClient::Exception => e
          raise Shippo::Exceptions::ConnectionError.new(connection_error_message(url, e))

        rescue StandardError => e
          raise Shippo::Exceptions::ConnectionError.new(connection_error_message(url, e)) if e.message =~ /TCP|connection|getaddrinfo/

          STDERR.puts "#{self.class.name}: Internal error occurred while connecting to #{url}: #{e.message}"
          STDERR.puts 'Stack Trace'
          STDERR.puts e.backtrace.join("\n")
          raise Shippo::Exceptions::Error.new(e)
        end
        self.parsed_response
      end

      private

      def shippo_phone_home
        payload     = {}
        request_url = url
        (method == :get) ? request_url = params_to_url(params, url) : payload = params.to_json
        setup_headers!(headers)
        opts = make_opts!(headers, method, payload, request_url)

        if Shippo::API.debug?
          puts "\nCLIENT REQUEST:"
          ap opts
        end

        make_request!(opts)
      end

      def make_request!(opts)
        RestClient::Request.execute(opts) { |response, &block|
          if [301, 302, 307].include? response.code
            response.follow_redirection(&block)
          else
            response.return!(&block)
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
        additional_hash = {
          :accept        => :json,
          :content_type  => :json,
          :Authorization => "ShippoToken #{token}"
        }
        additional_hash[:'Shippo-API-Version'] = version if version
        headers.merge!(additional_hash)
      end

      def awesome_print_response(e)
        begin
          h = JSON.parse(e.response)
          if h
            puts "\nSERVER RESPONSE:"
            ap JSON.parse(e.response)
          end
        rescue nil
        end
      end

      def base
        ::Shippo::API.base
      end

      def token
        ::Shippo::API.token
      end

      def version
        ::Shippo::API.version
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
