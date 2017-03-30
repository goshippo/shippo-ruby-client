lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'shippo'

Hashie.logger = Logger.new(nil)

Shippo::API.token = 'shippo_test_09e74f332aa839940e6c241bb008157c19428339'
DEFAULT_CARRIER_ACCOUNT = '903074429eab4954b72df8a70defdfe3'