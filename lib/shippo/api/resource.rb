require 'hashie/mash'
require 'active_support/inflector'
require 'shippo/exceptions'
require 'shippo/api/api_object'
module Shippo
  module API
    class Resource < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      include Enumerable

      attr_accessor :api_object

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
        # For each subclass we define helpers #url and #operations
        # allowing sublasses declare which operations they support.
        def inherited(klass)
          klass.instance_eval do
            @url = nil
            class << self
              # It's a getter and a class-level setter
              def url(value = nil)
                return @url if @url
                @url ||= value if value
                 @url ||= class_to_url
              end

              def class_to_url
                words = self.short_name.underscore.split(/_/)
                words.map{|w| "/#{w == words.last ? w.pluralize : w}" }.join
              end

              def operations(*ops)
                ops.each do |operation|
                  module_name = "Shippo::API::Operations::#{operation.to_s.capitalize}"
                  # noinspection RubyResolve
                  self.extend(module_name.constantize)
                end
              end
            end
          end
        end
      end

      # As a Hashie::Mash subclass, Resource can initialize from another hash
      def initialize(*args)
        if args[0].is_a?(Fixnum)
          self.id = [0]
        elsif args.first.respond_to?(:keys)
          h = args.first
          object_keys = h.keys.grep /#{Shippo::API::ApiObject::PREFIX}/ # [ 'object_owner', 'object_id', ...]
          h_object = {}
          object_keys.each { |k| h_object[k] = h[k] }
          self.api_object = ApiObject.new(h_object)
          object_keys.each { |k| args.first.delete(k) }
          super(*args)
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

