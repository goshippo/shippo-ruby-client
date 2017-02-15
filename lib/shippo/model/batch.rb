module Shippo
  class Batch < ::Shippo::API::Resource
    operations :create, :retrieve, :batch
  end
end