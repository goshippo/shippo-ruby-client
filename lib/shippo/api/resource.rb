require 'hashie/mash'
require 'active_support/inflector'
require 'shippo/exceptions'
module Shippo
  module API
    class Resource < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      include Enumerable

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

      class << self
        def inherited(klass)
          klass.instance_eval do
            @url = nil
            class << self
              # It's a getter and a class-level setter
              def url(value = nil)
                return @url if @url
                @url = value if value
                @url = "/#{short_name.downcase.pluralize}" unless @url
                @url
              end
            end
          end
        end
      end

      # As a Hashie::Mash subclass, Resource can initialize from another hash
      def initialize(*args)
        if args[0].is_a?(Fixnum)
          self.id = [0]
        else
          super(*args)
        end
      end

      def inspect
        id_string = (respond_to?(:id) && !id.nil?) ? " id=#{id}" : ''
        "#<#{self.class.name}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + to_s
      end

      def id
        self['object_id']
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
    end
  end
end

