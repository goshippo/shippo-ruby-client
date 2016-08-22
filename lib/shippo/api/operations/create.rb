require 'awesome_print'
module Shippo
  module API
    module Operations
      module Create
        # Creates an item in the database
        # @param [Hash] params tacked onto the URL as URI parameters
        def create(params={})
          api_params = params.dup
          Hashie::Extensions::StringifyKeys.stringify_keys!(api_params)

          api_params.dup.each { |k, v| api_params[k] = v.id if v.is_a?(::Shippo::API::Resource) && v.id }

          response = Shippo::API.post("#{url}/", api_params)
          instance = self.from(response)

          debug_log!(api_params, response, instance) if Shippo::API.debug?
          instance
        end

        def debug_log!(api_params, response, instance)
          puts "#{self.name}->create / request : \n"
          ap(api_params)
          puts "#{self.name}->create / response: \n"
          ap(response)
          puts "#{self.name}->create / from: \n"
          ap(instance)
        end
      end
    end
  end
end
