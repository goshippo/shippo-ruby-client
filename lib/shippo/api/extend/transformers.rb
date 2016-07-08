require_relative '../transformers/list.rb'
module Shippo
  module API
    module Extend
      module Transformers
        def transformers
          @transformers ||= [ Shippo::API::Transformers::List ].freeze
        end
      end
    end
  end
end
