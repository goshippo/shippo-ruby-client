require 'forwardable'

require 'hashie/mash'
require 'active_support/inflector'

require 'shippo/exceptions'

require_relative 'api_object'
require_relative 'category/status'
require_relative 'transformers/list'
require_relative 'extend/operation'
require_relative 'extend/transformers'
require_relative 'extend/url'

module Shippo
  module API
    class Resource < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      include Enumerable
      extend Forwardable

      disable_warnings

      attr_accessor :object

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

      def self.short_name(name = self.name)
        name.split('::')[-1]
      end

      # allows resources to use default or a custom url
      include Shippo::API::Extend::Url
      # allows resources to set supported operations
      include Shippo::API::Extend::Operation
      # adds #transformers method that enumerates available transformers
      # of the hashes into other types.
      include Shippo::API::Extend::Transformers

      # As a Hashie::Mash subclass, Resource can initialize from another hash
      def initialize(*args)
        if args.first.is_a?(Integer) or
          (args.first.is_a?(String) && args.first =~ /^[0-9A-Fa-f]+$/)
          self.id = args.first
        elsif args.first.respond_to?(:keys)
          h = Hashie::Mash.new(args.first)
          self.deep_merge!(h)
          self.object = ApiObject.create_object(self)
          transformers.each do |transformer|
            transformer.new(self).transform
          end
        else
          super(*args)
        end
      end

      def inspect
        "#<#{self.class.short_name}:0x#{self.object_id.to_s(16)}#{id.nil? ? '' : "[id=#{id}]"}#{to_hash.inspect}->#{object.inspect}"
      end

      def to_s
        self.class.short_name + self.to_hash.to_s + '->' + self.object.to_s
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

      def valid?
        self.object && self.object.state && self.object.state.eql?(Shippo::API::Category::State::VALID)
      end
    end
  end
end
