module Shippo
  module Exceptions
  end
end

require 'shippo/exceptions/error'
Dir[File.dirname(__FILE__) + '/exceptions/*.rb'].each {|file| require file }