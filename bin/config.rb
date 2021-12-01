lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'shippo'

Hashie.logger = Logger.new(nil)

Shippo::API.version = '2018-02-08'

if ENV["SHIPPO_TOKEN"]
    Shippo::API.token = ENV["SHIPPO_TOKEN"]
else
    puts 'API Token is missing, run: export SHIPPO_TOKEN="<your token here>"'
end
if ENV["DEFAULT_CARRIER_ACCOUNT"]
    DEFAULT_CARRIER_ACCOUNT = ENV["DEFAULT_CARRIER_ACCOUNT"]
else
    puts 'Default Carrier is missing, run: export DEFAULT_CARRIER_ACCOUNT="<your usps account object id>"'
end