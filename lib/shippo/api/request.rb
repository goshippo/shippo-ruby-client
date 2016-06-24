require 'rest_client'
require 'json'
require 'set'

module Shippo
  module Api
    #
    # This class is the primary Interface to the Shippo API.
    #
    #
    class Request

      # Optional
      attr_accessor :username, :password

      def initialize(username: nil, password: nil)
      end

      def api_url(uri_component = '')
        base + uri_component
      end

      def base
        ::Shippo::Api.base
      end

      def token
        ::Shippo::Api.token
      end

      # @param [symbol] method :get or any other method such as :put, :post, etc.
      # @param [String] uri_component URI component appended to the base URL
      # @param [Hash] params parameters to append to the URL
      # @param [Hash] headers headers hash sent to the server
      def execute(method,
                  uri_component,
                  params = {},
                  headers = {})
        validate!

        begin
          payload = {}
          url     = api_url(uri_component)

          (method == :get) ? url = params_to_url(params, url) : payload = params.to_json

          setup_headers!(headers)
          opts     = make_opts!(headers, method, payload, url)
          response = make_request!(opts)

        rescue => e
          handle_error!(e, url)
        end
        parse(response)
      end

      private

      def parse!(response)
        JSON::parse(response.body, { symbolize_names: true })
      end

      def handle_error!(e, url)
        case e
          when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
            msg = %Q[
          Could not connect to the Shippo API at #{base}.
          Please proceed to check your connection, try again and
          contact Shippo support should the issue persist.
          ].gsub(/^\s*/, '')
            raise ConnectionError.new msg + "\n\n(e.message)"
          when SocketError
            msg = "Unexpected error connecting to the Shippo API at #{url}."
          when RestClient::ExceptionWithResponse
            msg = "error: #{e} #{e.http_body}"
          else
            msg = "error: #{e}"
        end
        raise Shippo::Api::Error.new msg
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

      def params_to_url(params, url)
        pairs = []
        params.each { |k, v|
          pairs.push "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
        }
        url += "?#{pairs.join('&')}" unless pairs.empty?
        url
      end

      def validate!
        raise AuthError.new('API credentials missing! Make sure to set Shippo::Api.token') if self.token.empty?
      end
    end
  end
end


