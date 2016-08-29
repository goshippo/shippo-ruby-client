require 'codeclimate-test-reporter'
require 'pry'

CodeClimate::TestReporter.start

require 'rspec/core'
require 'shippo'

RSpec.configure do |config|
  config.before do
    srand 117
  end
end

Shippo::API.warnings = false
