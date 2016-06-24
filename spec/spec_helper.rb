require 'rspec/core'
require 'shippo'

RSpec.configure do |config|
  config.before do
    srand 117
  end
end

RSpec.shared_context :fake_serializer do
end
