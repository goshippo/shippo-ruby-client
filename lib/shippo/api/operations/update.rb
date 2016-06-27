module Shippo
  module API
    module Operations
      module Update
        def update(object_id, params={})
          response = Shippo::API.put("#{url}/#{CGI.escape(object_id)}/", params)
          self.from(response)
        end
      end
    end
  end
end
