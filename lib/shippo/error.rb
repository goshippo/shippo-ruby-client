module Shippo
  class APIError < StandardError
    attr_reader :message
    def initialize(message=nil)
      @message = message
    end

    def to_s
      @message
    end
  end
  class ConnectionError < APIError
  end
  class MissingDataError < APIError
  end
  class AuthError < APIError
  end
end
