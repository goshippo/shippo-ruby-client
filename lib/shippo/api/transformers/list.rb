require 'active_support/inflector'
module Shippo
  module API
    module Transformers
      # List Transformer: if it finds a key mapped to an array, this transformer coerces each element
      # into an appropriate model class – if available. As a result, return from, eg. +Shipment.create+
      # will contain +rates+ key that will no longer be an array of hashes, but an array of +Shippo::Rate+
      # instances.
      class List
        attr_accessor :h

        # +MATCHERS+ contains a list of procs that are used to try, in order, to convert a key
        # mapped to an array of hashes, into a word that represents an existing model.
        #
        # Each matcher receives a key as a parameter, and (if matches) it extracts the candidate word to be
        # attempted to +constantize+. For example, +rates+ matcher will return +rates+ as output.

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
