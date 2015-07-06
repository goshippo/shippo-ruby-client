module Shippo
  module Operations
    module Update
      module ClassMethods
        def update(object_id, params={})
          response = Shippo.request(:put, "#{url}/#{CGI.escape(object_id)}/", params)
          self.construct_from(response)
        end
      end
      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
