module Shippo
  module Api
    class Error < StandardError
      attr_accessor :message

      def initialize(message=nil)
        self.message = message
      end

      def to_s
        message
      end
    end
    class ConnectionError < Shippo::Api::Error; end
    class MissingDataError < Shippo::Api::Error; end
    class AuthError < Shippo::Api::Error; end

  end
end

