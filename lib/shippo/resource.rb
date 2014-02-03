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
      unless id = self['object_id']
        raise MissingDataError.new("#{self.class} has no object_id")
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
