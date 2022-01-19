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

  config.around do |example|
    state = Shippo::API.instance_variables.map { |name| [name, Shippo::API.instance_variable_get(name)] }
    example.run
    state.each { |name, value| Shippo::API.instance_variable_set(name, value) }
  end
end

Shippo::API.token = ENV["SHIPPO_TOKEN"]
Shippo::API.version = '2018-02-08'
Shippo::API.warnings = false

CARRIER = 'shippo'
DEFAULT_CARRIER_ACCOUNT = ENV["DEFAULT_CARRIER_ACCOUNT"]
DEFAULT_SERVICELEVEL_TOKEN = 'usps_priority'
TRACKING_NO = 'SHIPPO_TRANSIT'