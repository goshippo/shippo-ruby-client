class Shippo::Exceptions::APIError < ::Shippo::Exceptions::Error
  attr_accessor :message, :req
  def initialize(message = nil, req = nil)
    super(message)
    self.req = req
  end

  def to_s
    "#{self.class.name} ⇨ #{req.url}#{response} ⇨ #{message}"
  end

  def response
    req.response && req.response.http_code ? "[ ⇨ HTTP #{req.response.http_code} ]" : ''
  end
end

class Shippo::Exceptions::APIServerError < Shippo::Exceptions::APIError; end
class Shippo::Exceptions::InvalidCategoryValueError < Shippo::Exceptions::APIError; end

