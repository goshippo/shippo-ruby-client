module Shippo
  class Address < ::Shippo::API::Resource
    operations :list, :create, :validate
  end
end
