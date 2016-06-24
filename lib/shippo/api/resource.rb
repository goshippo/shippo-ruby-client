require 'active_support/inflector'
module Shippo
  module Api
    class Resource < ::Shippo::Api::ContainerObject
      def self.class_name
        self.name.split('::')[-1]
      end

      def self.inherited(klass)
        klass.instance_eval do
          @url = nil
          class << self
            def url(value = nil)
              return @url if @url
              @url = value if value
              @url = "/#{class_name.downcase.pluralize}" unless @url
              @url
            end
          end
        end
      end

      def url
        raise MissingDataError.new("#{self.class} has no object_id") unless id = self['object_id']
        "#{self.class.url}/#{CGI.escape(id)}"
      end

      def refresh
        response = Shippo::Api.request(:get, url)
        self.refresh_from(response)
        self
      end
    end
  end
end
