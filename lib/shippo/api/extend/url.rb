module Shippo
  module API
    module Extend
      module Url
        def self.included(klass)
          klass.instance_eval do
            @url = nil
            class << self
              # It's a getter and a class-level setter
              def url(value = nil)
                return @url if @url
                @url ||= value if value
                @url ||= class_to_url
              end

              def class_to_url
                words = self.short_name.underscore.split(/_/)
                words.map { |w| "/#{w == words.last ? w.pluralize : w}" }.join
              end
            end
          end
        end
      end
    end
  end
end
