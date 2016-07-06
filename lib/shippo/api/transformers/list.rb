module Shippo
  module API
    module Transformers
      # List Transformer: if it finds a key named like 'rates_list' it converts it
      # to another member 'rates' containing equivalent list of object instances of
      # the corresponding type, in the example above – Shippo::Rate.
      class List
        attr_accessor :hash

        def initialize(hash)
          self.hash = hash
        end

        def transform
          reg   = /([\w_]+)_list/
          lists = h.keys.select { |k| reg.match(k.to_s) && h[k].is_a?(Array) }
          lists.each do |list_key|
            convert_list(list_key, reg)
          end
        end

        private

        def h
          hash
        end

        def convert_list(list_key, reg)
          model = reg.match(list_key.to_s)[1] # extract the word eg 'rates'
          type  = model.singularize.capitalize if model # convert to Rate
          return unless type
          type_class = "Shippo::#{type}".constantize rescue nil # Instantiate Shippo::Rate
          return unless type_class
          h[model.to_sym] = h[list_key].map { |item| type_class.from(item) }
          h.delete(list_key)
          if Shippo::API.debug?
            puts "Converted array #{list_key} to #{model} of type #{type_class}, #{h[model.to_sym]}".bold.yellow
          end
        end
      end
    end
  end
end
