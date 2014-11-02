require 'rest_client'
require 'json'
require 'set'

require_relative 'shippo/error.rb'
require_relative 'shippo/container_object.rb'
require_relative 'shippo/api_object.rb'
require_relative 'shippo/list.rb'
require_relative 'shippo/create.rb'
require_relative 'shippo/resource.rb'
require_relative 'shippo/address.rb'
require_relative 'shippo/parcel.rb'
require_relative 'shippo/shipment.rb'
require_relative 'shippo/transaction.rb'
require_relative 'shippo/rate.rb'
require_relative 'shippo/manifest.rb'
require_relative 'shippo/customs_item.rb'
require_relative 'shippo/customs_declaration.rb'
require_relative 'shippo/refund.rb'
require_relative 'shippo/location.rb'

module Shippo
  @api_base = 'https://api.goshippo.com/v1'
  @api_version = 1.0
  @api_user = ''
  @api_pass = ''

  class << self
    attr_accessor :api_base, :api_version, :api_user, :api_pass
  end

  def self.api_url(url='')
    @api_base + url
  end

  def self.request(method, url, params = {}, headers = {})
    unless @api_user && @api_pass
      raise AuthError.new("API credentials missing! Make sure to set Shippo.api_user, Shippo.api_Pass")
    end
    begin
      payload = {}
      url = api_url(url)
      case method
      when :get
        pairs = []
        params.each { |k, v|
          pairs.push "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"
        }
        url += "?#{pairs.join('&')}" unless pairs.empty?
      when :post
        payload = params
      end
      opts = { :headers => headers,
        :method => method,
        :payload => payload,
        :url => url,
        :ssl_version => 'TLSv1_2',
        :open_timeout => 15,
        :timeout => 30,
        :user => @api_user,
        :password => @api_pass,
        :user_agent => "Shippo/v1 RubyBindings"
      }
      res = make_request(opts)
    rescue => e
      case e
      when RestClient::ServerBrokeConnection, RestClient::RequestTimeout
        msg = "Could not connect to the Shippo API at #{@api_base}. " +
        "Please proceed to check your connection, try again and " +
        "contact Shippo support should the issue persist."
        raise ConnectionError.new msg + "\n\n(e.message)"
      when SocketError
        msg = "Unexpected error connecting to the Shippo API at #{@api_base}."
      when RestClient::ExceptionWithResponse
        msg = "error: #{e} #{e.http_body}"
      else
        msg = "error: #{e}"
      end
      raise APIError.new msg
    end
    parse(res)
  end
  def self.parse(response)
    JSON::parse(response.body, { :symbolize_names => true })
  end
  def self.make_request(opts)
    RestClient::Request.execute(opts){ |response, request, result, &block|
      if [301, 302, 307].include? response.code
        response.follow_redirection(request, result, &block)
      else
        response.return!(request, result, &block)
      end
    }
  end
end
