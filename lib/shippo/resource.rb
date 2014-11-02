module Shippo
  class Resource < ApiObject
    @non_standard_URL
    def self.class_name
      self.name.split('::')[-1]
    end
    def self.url()
      # Process non standard URL
      if defined? @non_standard_URL
        return @non_standard_URL
      else
        # Process standard url
        dc = class_name.downcase
        "/" + dc + (dc[-1] == 's' ? 'es' : 's')
      end
    end

    def id
      self['object_id']
    end

    def url
      unless id
        raise MissingDataError.new("#{self.class} has no object_id")
      end
      "#{self.class.url}/#{CGI.escape(id)}"
    end

    def refresh
      response = Shippo.request(:get, url)
      refresh_from(response)
      self
    end
  end
end
