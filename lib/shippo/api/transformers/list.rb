require 'active_support/inflector'
module Shippo
  module API
    module Transformers
      # List Transformer: if it finds a key named like 'rates_list' it converts it
      # to another member 'rates' containing equivalent list of object instances of
      # the corresponding type, in the example above – Shippo::Rate.
      class List
        attr_accessor :h

        # Matchers receive a key as a parameter, and they extract a candidate word to be
        # tried in Coercing the values of the array to an object. For example, it could be
        # "shipments" or "rates_list" or "items".
        #
        # They are tried in order they are defined.

        MATCHERS = [
          ->(key) {
            case key.to_sym
              when :items
                :customs_items
              else
                nil
            end
          },

          ->(key) {
            reg = /^([\w_]+)_list$/
            reg.match(key.to_s) ? reg.match(key.to_s)[1] : nil
          },

          ->(key) {
            reg = /^([\w_]+s)$/
            reg.match(key.to_s) ? reg.match(key.to_s)[1] : nil
          }
        ]

        def initialize(hash)
          self.h = hash
        end

        def transform
          h.keys.each { |k| h[k].is_a?(Array) && !h[k].empty? }.each do |list_key|
            type, *values = transform_list(list_key, h[list_key])
            h[list_key]   = values if type
          end
        end

        private

        def detect_type_class(model_name)
          type = model_name.to_s.singularize.camelize
          "Shippo::#{type}".constantize rescue nil
        end

        def detect_type_name(list_key)
          results = MATCHERS.map { |m| m.call(list_key) }.compact
          results.is_a?(Array) && results.size > 0 ? results.first : nil
        end

        def transform_list(list_key, array)
          if (type_name = detect_type_name(list_key)) &&
            (type_class = detect_type_class(type_name))
            type_array = array.map { |item| type_class.from(item) }
            return type_name, *type_array
          else
            nil
          end
        end
      end
    end
  end
end
