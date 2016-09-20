require 'shippo/exceptions/api_error'

module Shippo
  module Exceptions
    #
    # The +APIServerError+ happens when the server returns a parseable JSON response,
    # but when such response indicates a failed operation due to either
    # validation or other business, data or logic issues.
    #
    # The error adds the HTTP response message member, which would typically be
    # "400 Bad Request"
    #
    class APIServerError < APIError

      def initialize(message = nil, request = nil, response = nil, http_response_message = nil)
        super(message, request, response)
        self.http_response_message = http_response_message
      end

      def to_s_members
        %i(http_response_message) + super
      end
    end
  end
end
