require 'rest_client'
require 'json'
require 'set'

module Shippo
  module Api
    @api_base    = 'https://api.goshippo.com/v1'
    @api_version = 1.0
    @api_token   = ''

    class << self
      attr_accessor :api_base, :api_version, :api_token

      def api_url(url='')
        self.api_base + url
      end
    end
  end
end

Shippo.require_all_from('shippo/api')

require 'shippo/operations'
require 'shippo/model'

module Shippo
  module Api

    def self.request(method, url, params = {}, headers = {})
      if @api_token.empty?
        raise AuthError.new('API credentials missing! Make sure to set Shippo.api_token')
      end
      begin
        payload = {}
        url     = api_url(url)
        headers.merge!(
          :accept        => :json,
          :content_type  => :json,
          :Authorization => "ShippoToken #{@api_token}"
        )
        case method
          when :get
            pairs = []
            params.each { |k, v|
              pairs.push "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
            }
            url += "?#{pairs.join('&')}" unless pairs.empty?
          else
            payload = params.to_json
        end
        opts = { :headers      => headers,
                 :method       => method,
                 :payload      => payload,
                 :url          => url,
                 :open_timeout => 15,
                 :timeout      => 30,
                 :user         => @api_user,
                 :password     => @api_pass,
                 :user_agent   => 'Shippo/v2.0 RubyBindings'
        }
        res  = make_request(opts)
      rescue => e
        case e
          when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
            msg = %Q[
          Could not connect to the Shippo API at #{@api_base}.
          Please proceed to check your connection, try again and
          contact Shippo support should the issue persist.
          ].gsub(/^\s*/, '')
            raise ConnectionError.new msg + "\n\n(e.message)"
          when SocketError
            msg = "Unexpected error connecting to the Shippo API at #{@api_base}."
          when RestClient::ExceptionWithResponse
            msg = "error: #{e} #{e.http_body}"
          else
            msg = "error: #{e}"
        end
        raise Shippo::Api::Error.new msg
      end
      parse(res)
    end

    def self.parse(response)
      JSON::parse(response.body, { symbolize_names: true })
    end

    def self.make_request(opts)
      RestClient::Request.execute(opts) { |response, request, result, &block|
        if [301, 302, 307].include? response.code
          response.follow_redirection(request, result, &block)
        else
          response.return!(request, result, &block)
        end
      }
    end
  end
end
Shippo.require_all_from('shippo/api')
