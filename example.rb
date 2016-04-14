# This example demonstrates how to purchase a label for a domestic US shipment.
require 'shippo'

# replace <YOUR_PRIVATE_KEY> with your ShippoToken key
Shippo::api_token = '<YOUR_PRIVATE_KEY>'

# Create address_from object
address_from = {
  :object_purpose => 'PURCHASE',
  :name => 'Mr Hippo',
  :company => 'Shippo',
  :street1 => '215 Clayton St.',
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
  :name => 'Mrs Hippo"',
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
  :width => 2,
  :height => 5,
  :distance_unit => :in,
  :weight => 2,
  :mass_unit => :lb}

# Creating the shipment object
puts "Creating shipment object.."
shipment = Shippo::Shipment.create(
  :object_purpose => 'PURCHASE',
  :address_from => address_from,
  :address_to => address_to,
  :parcel => parcel,
  :async => false )

# Get the desired rate according to your business logic
# We select the first rate in this example
rate = shipment.rates()[0]

puts "Rates generated. Purchasing a #{rate.provider} #{rate.servicelevel_name} label"

# Purchase the desired rate (create a Transaction object)
transaction = Shippo::Transaction.create(
  :rate => rate["object_id"],
  :async => false )

# label_url and tracking_number
if transaction.object_status == "SUCCESS"
  puts "Label sucessfully generated:"
  puts "label_url: #{transaction.label_url}" 
  puts "tracking_number: #{transaction.tracking_number}" 
else
  puts "Error generating label:"
  puts transaction.messages
end
