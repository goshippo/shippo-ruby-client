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
    #       "object_state" => "VALID",
    #     "object_purpose" => "PURCHASE",
    #      "object_source" => "FULLY_ENTERED",
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
    # address = Shippo::Model::Address.from(response)
    # address.name
    # # ⤷ Shawn Ippotle
    # require 'ap'
    # ap address.object
    # # ⤷
    # {
    #       :state => #<Shippo::API::Category::State:0x007fd374b4d0d0 @name=:state, @value=:valid>,
    #     :purpose => #<Shippo::API::Category::Purpose:0x007fd373df2070 @name=:purpose, @value=:purchase>,
    #      :source => #<Shippo::API::Category::Source:0x007fd374b4fbf0 @name=:source, @value=:fully_entered>,
    #     :created => 2014-07-16 23:20:31 UTC,
    #     :updated => 2014-07-16 23:20:31 UTC,
    #          :id => "747207de2ba64443b645d08388d0309c",
    #       :owner => "shippotle@goshippo.com"
    # }
    # ```
    class ApiObject < Hashie::Dash
      include Hashie::Extensions::Dash::PropertyTranslation


      PREFIX           = { id: 'remote_', default: 'object_' }

      class << self
        def prefix(prop)
          Shippo::API::ApiObject::PREFIX[prop.to_sym] || Shippo::API::ApiObject::PREFIX[:default]
        end

        def matches_prefix?(value)
          %r[^(#{PREFIX.values.join('|')})].match(value.to_s)
        end

        def mk_opts(property)
          { with: ->(value) { value }, from: "#{self.prefix(property)}#{property}".to_sym, required: false }
        end
      end

      # list of allowed properties, of a given type.
      PROPS_FIXNM      = %i()
      PROPS_ID         = %i(id)
      PROPS_STRNG      = %i()
      PROPS_CATEG      = %i(state purpose source status)
      PROPS_EMAIL      = %i(owner)
      PROPS_TIMED      = %i(created updated)

      PROPS            = (PROPS_ID + PROPS_STRNG + PROPS_FIXNM + PROPS_EMAIL + PROPS_TIMED + PROPS_CATEG ).flatten
      PROPS_AS_IS      = (PROPS_STRNG + PROPS_EMAIL + PROPS_FIXNM + PROPS_ID)

      PROPS_TIMED.each { |prop| property prop, self.mk_opts(prop).merge(with: ->(value) { Time.parse(value) } ) }
      PROPS_AS_IS.each { |prop| property prop, self.mk_opts(prop) }

      PROPS_EMAIL.each { |prop| property prop, self.mk_opts(prop).merge(with: ->(value) {
          value && value.strip!
          value = "#{value}@gmail.com" if value and value !~ %r[.*@.*\..*]
          value
        })
      }
      PROPS_CATEG.each { |prop| property prop, self.mk_opts(prop).merge(with: ->(value) {
        Shippo::API::Category.for(prop, value)
        })
      }

      def initialize(*args)
        opts = args[0]
        if opts.respond_to?(:keys)
          Hashie::Extensions::StringifyKeys.stringify_keys!(opts)
          if opts['object_id']
            opts['remote_id'] = opts['object_id']
            opts.delete('object_id')
          end
          Hashie::Extensions::SymbolizeKeys.symbolize_keys!(opts)
        end
        super *args
      end

    end
  end
end
