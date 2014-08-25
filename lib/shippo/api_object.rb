module Shippo
  class ApiObject < ContainerObject
    include Enumerable

    def initialize(id=nil)
      # parameter overloading!
      if id.kind_of?(Hash)
        id = id[:id]
      end

      @values = {}
      @values[:id] = id if id
    end

    def self.construct_from(values)
      # recursive on arrays
      case values
      when Array
        values.map { |v| self.construct_from(v) }
      when Hash
        obj = self.new(values[:id])
        obj.refresh_from(values)
        obj
      else
        # on scalar types, just identity 
        values
      end
    end

    def to_s(*args)
      JSON.pretty_generate @values
    end

    def inspect()
      id_string = (self.respond_to?(:id) && !self.id.nil?) ? " id=#{self.id}" : ""
      "#<#{self.class}:0x#{self.object_id.to_s(16)}#{id_string}> JSON: " + self.to_s
    end

    def refresh_from(values)
      values.each do |k, v|
        @values[k.to_sym] = v
      end
      instance_eval do
        add_accessors(@values.keys)
      end

    end
    def [](k)
      @values[k.to_sym]
    end

    def []=(k, v)
      send(:"#{k}=", v)
    end
    def keys
      @values.keys
    end

    def values
      @values.values
    end

    def to_json(*a)
      JSON.dump(@values)
    end

    def as_json(*a)
      @values.as_json(*a)
    end

    def to_hash
      @values
    end

    def each(&blk)
      @values.each(&blk)
    end

    if RUBY_VERSION < '1.9.2'
      def respond_to?(symbol)
        @values.has_key?(symbol) || super
      end
    end


  end


end
