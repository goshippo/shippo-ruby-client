require 'hashie/dash'
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
    # ap address.api_object
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

      PREFIX           = 'object_'

      # list of allowed properties, of a given type.
      PROPS_FIXNM      = %i()
      PROPS_STRNG      = %i(id)
      PROPS_CATEG      = %i(state purpose source)
      PROPS_EMAIL      = %i(owner)
      PROPS_TIMED      = %i(created updated)

      PROPS            = (PROPS_STRNG + PROPS_FIXNM + PROPS_EMAIL + PROPS_TIMED + PROPS_CATEG ).flatten

      PROPS.each       { |prop| property prop, from: "#{PREFIX}#{prop}" }
      PROPS_TIMED.each { |prop| property prop, transform_with: ->(value) { Time.parse(value) } }
      PROPS_EMAIL.each { |prop| property prop, transform_with: ->(value) {
          raise ArgumentError.new("Invalid email #{value}") unless value =~ %r[.*@.*\..*]; value.strip
        }
      }
      PROPS_CATEG.each { |prop| property prop, transform_with: ->(value) {
          "Shippo::API::Response::#{prop.capitalize}".constantize.new(value)
        }
      }
      PROPS_CATEG.each { |prop| property prop, transform_with: ->(value) { Shippo::API::Category.for(prop, value)} }
    end
  end
end
