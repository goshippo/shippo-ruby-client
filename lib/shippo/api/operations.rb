module Shippo
  module API
    module Operations
    end
  end
end

Dir[File.dirname(__FILE__) + '/operations/*.rb'].each {|file| require file }