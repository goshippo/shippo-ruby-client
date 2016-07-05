require 'hashie/mash'
require 'active_support/inflector'
require 'shippo/exceptions'
require 'shippo/api/api_object'
require 'shippo/api/category/status'
require 'forwardable'
module Shippo
  module API
    class Resource < Hashie::Mash
      include Hashie::Extensions::StringifyKeys
      include Enumerable
      extend Forwardable

      attr_accessor :object
      def_delegators :@object, :id, :status, :state, :created, :updated

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
          # [ 'object_owner', 'object_id', ...]
          convert_object_fields(h)
          # { 'rates_list' => [ ... ] }
          convert_resource_lists(h)
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

      private


      def convert_object_fields(h)
        object_keys = h.keys.select { |k| Shippo::API::ApiObject.matches_prefix?(k) }
        h_object    = {}
        object_keys.each { |k| h_object[k] = h[k] }
        self.object = ApiObject.new(h_object)
        object_keys.each { |k| h.delete(k) }
      end

      def convert_resource_lists(h)
        reg   = /([\w_]+)_list/
        lists = h.keys.select { |k| reg.match(k.to_s) && h[k].is_a?(Array) }
        lists.each do |list_key|
          model = reg.match(list_key.to_s)[1]
          type  = model.singularize.capitalize if model
          if type
            type_class = "Shippo::Model::#{type}".constantize rescue nil
            if type_class
              h[model.to_sym] = h[list_key].map { |item| type_class.from(item) }
              h.delete(list_key)
              puts "Converted array #{list_key} to #{model} of type #{type_class}, #{h[model.to_sym]}".bold.yellow if Shippo::API.debug?
            end
          end
        end
      end

    end
  end
end

