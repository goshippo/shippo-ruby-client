require_relative 'shippo/dependency_loader'

module Shippo
  class << self
    include Shippo::DependencyLoader
  end
end

require 'shippo/api'

