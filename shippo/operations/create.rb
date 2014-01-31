module Shippo
  module Operations
    module Create
      module ClassMethods
        def create(params={})
          response = Shippo.request(:post, self.url, params)
          self.construct_from(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
