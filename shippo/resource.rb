module Shippo
  class Resource < ApiObject
    def self.class_name
      self.name.split('::')[-1]
    end
    def self.url()
      dc = class_name.downcase
      "/" + dc + (dc[-1] == 's' ? 'es' : 's')
    end
    def url
      unless id = self['id']
        # TODO
        raise InvalidRequestError.new("Could not determine which URL to request: #{self.class} instance has invalid ID: #{id.inspect}", 'id')
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
      response, api_key = Shippo.request(:get, url, @retrieve_options)
      refresh_from(response)
      self
    end
  end
end
