# This example demonstrates how to purchase a label for a domestic US shipment.
require 'shippo'
require 'timeout'

# replace <YOUR_PRIVATE_KEY> with your ShippoToken key
Shippo::api_token = '<YOUR_PRIVATE_KEY>'

# Create address_from object
address_from = {
  :object_purpose => 'PURCHASE',
  :name => 'Laura Behrens Wu',
  :company => 'Shippo',
  :street1 => 'Clayton St.',
  :street_no => '215',
  :street2 => '',
  :city => 'San Francisco',
  :state => 'CA',
  :zip => '94117',
  :country => 'US',
  :phone => '+1 555 341 9393',
  :email => 'support@goshippo.com'}

# Create address_to object
address_to = {
  :object_purpose => 'PURCHASE',
  :name => 'Mr Hippo"',
  :company => 'San Diego Zoo',
  :street1 => '2920 Zoo Drive',
  :city => 'San Diego',
  :state => 'CA',
  :zip => '92101',
  :country => 'US',
  :phone => '+1 555 341 9393',
  :email => 'hippo@goshippo.com'}

# Create parcel object
parcel = {
  :length => 5,
  :width => 1,
  :height => 5.555,
  :distance_unit => :cm,
  :weight => 2,
  :mass_unit => :lb}

# Creating the shipment object
puts "Creating shipment object.."
shipment = Shippo::Shipment.create(
  :object_purpose => 'PURCHASE',
  :submission_type => 'DROPOFF',
  :address_from => address_from,
  :address_to => address_to,
  :parcel => parcel)

puts "Shipment created. Waiting for rates to be generated.."

# Wait for rates to be generated
timeout_rates_request = 25 # seconds
while ["QUEUED","WAITING"].include? shipment.object_status do
  Timeout::timeout(timeout_rates_request) do
    shipment = Shippo::Shipment.get(shipment["object_id"])
  end
end

# Get all rates for shipment.
rates = shipment.rates()

# Get the first rate in the rates results
rate = rates[0]

puts "Rates generated. Purchasing a #{rate.provider} #{rate.servicelevel_name} label"

# Purchase the desired rate (create a Transaction object)
transaction = Shippo::Transaction.create(:rate => rate["object_id"])

# Wait for transaction to be proccessed
timeout_label_request = 25 # seconds
while ["QUEUED","WAITING"].include? transaction.object_status do
  Timeout::timeout(timeout_label_request) do
    transaction = Shippo::Transaction.get(transaction["object_id"])
  end
end

# label_url and tracking_number
if transaction.object_status == "SUCCESS"
  puts "Label sucessfully generated:"
  puts "label_url: #{transaction.label_url}" 
  puts "tracking_number: #{transaction.tracking_number}" 
else
  puts "Error generating label:"
  puts transaction.messages
end
