module Shippo
  class ContainerObject
    protected
    def create_accessor(k_name, k_index)
      metaclass.instance_eval do
        define_method(k_name) { @values[k_index] }
        define_method(:"#{k_name}=") do |v|
          @values[k_index] = v unless k_index == ''
        end
      end
    end
    def add_accessors(keys)
      keys.each do |k|
        #TODO raise something here, should filter this before
        orig_k = k
        while respond_to?(k) do
          k = "_#{k}".to_sym
        end
        create_accessor(k, orig_k)
      end
    end
    def metaclass
      class << self
        self
      end
    end
  end
end
