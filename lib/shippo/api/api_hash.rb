require 'hashie/mash'
require 'hashie/extensions/stringify_keys'

module Shippo
  module API
    class ApiHash < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      disable_warnings
    end
  end
end