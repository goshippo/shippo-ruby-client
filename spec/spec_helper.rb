require 'pry'
require 'simplecov'

SimpleCov.start

require 'vcr'
require 'rspec/core'
require 'webmock/rspec'
require 'shippo'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures'
  config.hook_into :webmock
  config.filter_sensitive_data('<API_TOKEN>') do |interaction|
    interaction.request.headers['Authorization'].first
  end
end

RSpec.configure do |config|
  config.before do
    srand 117
  end
end

Shippo::API.token = 'shippo_test_09e74f332aa839940e6c241bb008157c19428339'
Shippo::API.version = '2017-03-29'
Shippo::API.warnings = false

CARRIER = 'usps'
DEFAULT_CARRIER_ACCOUNT = '903074429eab4954b72df8a70defdfe3'
DEFAULT_SERVICELEVEL_TOKEN = 'usps_priority'
TRACKING_NO = '9205590164917312751089'