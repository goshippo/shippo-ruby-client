module Shippo
  module Operations
    module Create
      module ClassMethods
        def create(params={})
          params.each do |k, v|
            params[k] = v[:object_id] if v.is_a?(ApiObject)
          end
          response = Shippo.request(:post, "#{self.url}/", params)
          self.construct_from(response)
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
