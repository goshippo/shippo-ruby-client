module Shippo
  module API
    module Extend
      module Operation
        def self.included(klass)
          klass.instance_eval do
            class << self
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
    end
  end
end
