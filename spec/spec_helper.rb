require 'pry'
require 'simplecov'

SimpleCov.start

require 'rspec/core'
require 'webmock/rspec'
require 'shippo'


RSpec.configure do |config|
  config.before do
    srand 117
  end
end

Shippo::API.warnings = false
