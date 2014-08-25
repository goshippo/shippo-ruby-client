module Shippo
  module Operations
    module List
      module ClassMethods
        # return all items
        def all(params={})
          response = Shippo.request(:get, "#{url}/", params)
          # Limiting to results array, does not allow user to see count,..
          # self.construct_from(response[:results] || [])
          self.construct_from(response)
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
