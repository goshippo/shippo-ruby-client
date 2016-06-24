require 'hashie/mash'
require 'hashie/extensions/stringify_keys'

module Shippo
  module Api
    class ContainerObject < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      include Enumerable

      def initialize(*args)
        if args[0].is_a?(Fixnum)
          self.id = [0]
        else
          super(*args)
        end
      end

      def self.construct_from(_values)
        # recursive on arrays
        case _values
          when Array
            _values.map { |v| construct_from(v) }
          when Hash
            new(_values)
          else
            # on scalar types, just identity
            _values
        end
      end

      def inspect
        id_string = (respond_to?(:id) && !id.nil?) ? " id=#{id}" : ''
        "#<#{self.class.name}:0x#{object_id.to_s(16)}#{id_string}> JSON: " + to_s
      end
    end
  end
end
