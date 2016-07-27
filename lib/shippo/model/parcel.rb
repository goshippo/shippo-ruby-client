module Shippo
  class Parcel < ::Shippo::API::Resource
    operations :list, :create
  end
end
