require 'forwardable'

require 'hashie/mash'
require 'active_support/inflector'

require 'shippo/exceptions'

require_relative 'api_object'
require_relative 'category/status'
require_relative 'transformers/list'
require_relative 'extend/operation'
require_relative 'extend/url'

module Shippo
  module API
    class Resource < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      include Enumerable
      extend Forwardable

      def self.object_properties
        Shippo::API::ApiObject::PROPS
      end

      attr_accessor :object
      def_delegators :@object, *object_properties

      # Creates a possibly recursive chain (map of lists, etc) of Resource
      # instances based on whether each value is a scalar, array or a hash.
      def self.from(values)
        # recursive on arrays
        if values.is_a?(Array)
          values.map { |list| from(list) }
        elsif values.respond_to?(:keys) # a Hash or a Hash derivative
          new(values)
        else
          values
        end
      end

      def self.short_name
        self.name.split('::')[-1]
      end

      # Generate object_ accessors.
      object_properties.each do |property|
        method_name = ApiObject.field_name(property)
        define_method method_name do
          STDOUT.puts "#{method_name} style accessors are deprecated in favor of #resource.object.#{property}" if Shippo::API.warnings
          self.object.send(property)
        end
      end

      # allows resources to use default or a custom url
      include Shippo::API::Extend::Url
      # allows resources to set supported operations
      include Shippo::API::Extend::Operation

      ENABLED_TRANSFORMERS = [ Shippo::API::Transformers::List ]

      # As a Hashie::Mash subclass, Resource can initialize from another hash
      def initialize(*args)
        if args[0].is_a?(Fixnum)
          self.id = [0]
        elsif args.first.respond_to?(:keys)
          h = args.first
          # [ 'object_owner', 'object_id', ...]
          self.object = ApiObject.create_object(h)
          # { 'rates_list' => [ ... ] }
          ENABLED_TRANSFORMERS.each do |transformer|
            transformer.new(h).transform
          end
          super(h)
        else
          super(*args)
        end
      end

      def inspect
        "#<#{self.class.name}:0x#{self.object_id.to_s(16)}#{id.nil? ? '' : ":[id=#{id}]"}" + to_s + '>'
      end

      def to_s
        self.to_hash.to_s + '|' + self.object.to_s
      end

      def url
        raise Shippo::Exceptions::MissingDataError.new("#{self.class} has no object_id") unless id
        "#{self.class.url}/#{CGI.escape(id)}"
      end

      def refresh
        response = Shippo::API.get(url)
        self.from(response)
        self
      end

      def success?
        self.object && self.object.status && self.object.status.eql?(Shippo::API::Category::Status::SUCCESS)
      end
    end
  end
end

