module Shippo
  module API
    module Category
      # +Base+ is a convenience abstract class that provides the following functionality
      # to it's subclasses, which are meant to be enumerations with a fixed number of possible
      # values.
      #
      # Base populates a global hash +Shippo::API::Category.categories+ which is keyed by the
      # lower cased and symbolized category name (eg, :status or :purpose), each value is another
      # hash consisting of keys (values of each category, eg :success, :error) and value being the
      # constant created for such a value.
      #
      # __WARNING__: You are not supposed to instantiate these classes, to be honest. The
      # "correct" way is via the Facåde +Shippo::API::Category.for(name, value)+.
      #
      # == Example
      #
      # ```ruby
      # require 'shippo/api'
      # class Size < ::Shippo::API::Category::Base
      #   allowed_values :small, :medium, :large, :xlarge, :xxlarge
      # end
      # # ⤷ [:small, :medium, :large, :xlarge, :xxlarge]
      #
      # my_size = Shippo::API::Category.for('size', 'xlarge')
      # # ⤷ size:xlarge
      #
      # my_size.xlarge?
      # # ⤷ true
      # my_size.medium?
      # # ⤷ false
      # my_size.name
      # # ⤷ size
      # my_size.value
      # # ⤷ xlarge
      #
      # medium_1 = Size.new('medium')
      #  ⤷ size:medium
      # medium_2 = Size.new('medium')
      #  ⤷ size:medium
      # medium_3 = Shippo::API::Category.for(:size, :medium)
      #  ⤷ size:medium
      #
      # # But keep in mind these instances are all different objects,
      # # which are +eql?()+ to each other, but not identical.
      # medium_1.object_id
      # # ⤷ 70282669124280
      # medium_2.object_id
      # # ⤷ 70282669580500
      # medium_3.object_id
      # # ⤷ 70282681963740
      # medium_1.eql?(medium_2)
      # # ⤷ true
      # medium_2.eql?(medium_3)
      # # ⤷ true
      # ```
      #
      class Base

        @categories = Shippo::API::Category.categories
        class << self
          attr_accessor :categories
        end

        def self.inherited(klazz)
          klazz.instance_eval do
            @allowed_values = Set.new
            class << self
              def categories
                ::Shippo::API::Category::Base.categories
              end

              def value_transformer(values)
                values.map(&:downcase).map(&:to_sym)
              end

              def allowed_values(*values)
                return @allowed_values if values.nil? || values.empty? || !@allowed_values.empty?

                @allowed_values = self.value_transformer(values)
                @allowed_values.each do |allowed_value|
                  category_value = Category.key(allowed_value)
                  category_const = category_value.to_s.upcase

                  raise ::Shippo::API::Category::DuplicateValueError.new(
                    "Constant #{category_const} is already defined in #{self.name}") if self.const_defined?(category_const)

                  new_instance = self.new(category_value)
                  self.const_set(category_const, new_instance)

                  define_method "#{category_value}?".to_sym do
                    value.eql?(category_value)
                  end

                  categories[new_instance.name]                     ||= {}
                  categories[new_instance.name][new_instance.value] = new_instance
                end
              end
            end
          end
        end

        attr_accessor :name, :value

        def initialize(value)
          raise ::Shippo::Exceptions::AbstractClassInitError.new('Can not instantiate Base!') if self.class.eql?(::Shippo::API::Category::Base)
          self.name = Category.key(self.class.name.gsub(%r{.*::}, ''))
          self.value = assign_value(value)
        end

        def eql?(other)
          self.class.eql?(other.class) && self.value.eql?(other.value)
        end

        def to_s
          "#{self.value.upcase}"
        end

        private

        def value_allowed?(value)
          self.class.allowed_values.include?(value)
        end

        def assign_value(value)
          value = clean(value)

          if value_allowed?(value)
            @value = value
          else
            raise ::Shippo::Exceptions::InvalidCategoryValueError.new(
              "Value #{value} is not allowed for Category #{self.class.name}, allowed values are: #{self.class.allowed_values})")
          end
          @value
        end

        def clean(value)
          Category.key(value)
        end

      end
    end
  end
end
