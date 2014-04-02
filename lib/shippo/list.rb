module Shippo
  module Operations
    module List
      module ClassMethods
        # return all items
        def all(params={})
          response = Shippo.request(:get, "#{url}/", params)
          self.construct_from(response[:results] || [])
        end
        # return a specific item
        def get(id, params={})
          response = Shippo.request(:get, "#{url}/#{CGI.escape(id)}/", params)
          self.construct_from(response)
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
      end
    end
  end
end
