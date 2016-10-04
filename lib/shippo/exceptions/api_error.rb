module Shippo
  module Exceptions
    class APIError < ::Shippo::Exceptions::Error
      attr_accessor :request,
                    :response,
                    :http_response_message


      def initialize(message = nil,
                     request = nil,
                     response = nil)
        super(message)
        self.request  = request
        self.response = response
      end

      def to_s_members
        super + %i(server_url response)
      end

      def server_url
        @server_url ||= (request ? request.url : '')
      end
    end
  end
end


class Shippo::Exceptions::UnsuccessfulResponseError < Shippo::Exceptions::APIError;
end
class Shippo::Exceptions::InvalidCategoryValueError < Shippo::Exceptions::APIError;
end
class Shippo::Exceptions::InvalidJsonError < Shippo::Exceptions::APIError;
end

