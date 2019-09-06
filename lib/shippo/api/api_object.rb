require 'hashie/dash'
require 'hashie/extensions/stringify_keys'
require 'hashie/extensions/symbolize_keys'
require 'hashie/extensions/dash/property_translation'
require 'active_support/inflector'

module Shippo
  module API
    # +ApiObject+ is a class that contains only a set of specific fields
    # that can be used in both requests and responses from Shippo API.
    # Upon return with each response, +ApiObject+ instance is automatically
    # created and populated with fields that begin with a prefix `object_`.
    # The prefix is deleted, and the fields are made available through the
    # non-prefixed accessors.
    #
    # This class uses +Hashie::Dash+ under the hood, in order to provide convenient
    # transformations, support required/optional attributes, etc.
    #
    #
    # == Example
    #
    # ```ruby
    # response = {
    #       "object_state" => "VALID",    # not available for address, shipment or rates
    #     "object_created" => "2014-07-16T23:20:31.089Z",
    #     "object_updated" => "2014-07-16T23:20:31.089Z",
    #          "object_id" => "747207de2ba64443b645d08388d0309c",
    #       "object_owner" => "shippotle@goshippo.com",
    #               "name" => "Shawn Ippotle",
    #            "company" => "Shippo",
    #            "street1" => "215 Clayton St.",
    #            "street2" => "",
    #               "city" => "San Francisco",
    #              "state" => "CA",
    #                "zip" => "94117",
    #            "country" => "US",
    #              "phone" => "+1 555 341 9393",
    #              "email" => "shippotle@goshippo.com"
    # }
    #
    # require 'shippo'
    # address = Shippo::Address.from(response)
    # address.name
    # # ⤷ Shawn Ippotle
    # require 'ap'
    # ap address.object
    # # ⤷
    # {
    #       :state => #<Shippo::API::Category::State:0x007fd374b4d0d0 @name=:state, @value=:valid>,
    #     :created => 2014-07-16 23:20:31 UTC,
    #     :updated => 2014-07-16 23:20:31 UTC,
    #          :id => "747207de2ba64443b645d08388d0309c",
    #       :owner => "shippotle@goshippo.com"
    # }
    # ```
    class ApiObject < Hashie::Dash
      include Hashie::Extensions::Dash::PropertyTranslation

      PREFIX           = { id: 'resource_', default: 'object_' }.freeze

      class << self
        def field_name(property)
          "#{PREFIX[property.to_sym] || PREFIX[:default]}#{property}".to_sym
        end

        def matches_prefix?(value)
          %r[^(#{PREFIX.values.join('|')})].match(value.to_s)
        end

        def mk_opts(property)
          { with: ->(value) { value }, from: "#{field_name(property)}".to_sym, required: false }
        end
      end

      # list of allowed properties, of a given type.
      PROPS_ID         = %i(id).freeze
      PROPS_CATEG      = %i(state status results).freeze
      PROPS_EMAIL      = %i(owner).freeze
      PROPS_TIMED      = %i(created updated).freeze

      PROPS            = (PROPS_ID + PROPS_EMAIL + PROPS_TIMED + PROPS_CATEG ).flatten.freeze
      PROPS_AS_IS      = (PROPS_EMAIL + PROPS_ID).freeze

      def self.setup_property(prop, custom = {})
        property prop, self.mk_opts(prop).merge(custom)
      end

      PROPS_AS_IS.each { |prop| setup_property(prop) }
      PROPS_TIMED.each { |prop| setup_property(prop, with: ->(value) { Time.parse(value) } ) }
      PROPS_EMAIL.each { |prop| setup_property(prop, with: ->(value) {
          value && value.strip!
          value = "#{value}@gmail.com" if value and value !~ %r[.*@.*\..*]
          value
        })
      }
      PROPS_CATEG.each { |prop| setup_property(prop, with: ->(value) {
        Shippo::API::Category.for(prop, value)
        })
      }

      def self.create_object(h)
        object_keys = h.keys.select { |k| matches_prefix?(k) }
        h_object    = {}
        object_keys.each { |k| h_object[k.to_s] = h[k] }
        instance = self.new(h_object)
        object_keys.each { |k| h.delete(k) if h.key(k) }
        instance
      end

      def initialize(*args)
        opts = args.first
        if opts && opts.respond_to?(:keys)
          Hashie::Extensions::SymbolizeKeys.symbolize_keys!(opts)
          if opts[:object_id]
            opts[(PREFIX[:id] + 'id').to_sym] = opts[:object_id]
            opts.delete(:object_id)
          end
          super(opts)
        else
          super(args)
        end
      end

      def to_s
        Shippo::API::Resource.short_name(self.class.name) + self.to_hash.to_s
      end
    end
  end
end
