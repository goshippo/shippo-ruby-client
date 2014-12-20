# This example demonstrates how to purchase a label for an international shipment.
# Creating domestic shipment would follow a similiar proccess but would not require
# the creation of CustomsItems and CustomsDeclaration objects.
require 'shippo'

 #replace <USERNAME> and <PASSWORD> with your credentials
Shippo::api_user = '<USERNAME>'
Shippo::api_pass = '<PASSWORD>'

#Create address_from object
address_from =Shippo::Address.create(
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
  :email => 'laura@goshippo.com')

#Create address_to object
address_to = Shippo::Address.create(
  :object_purpose => 'PURCHASE',
  :name => 'Mr Hippo"',
  :company => 'London Zoo"',
  :street1 => 'Regents Park',
  :street2 => 'Outer Cir',
  :city => 'LONDON',
  :state => '',
  :zip => 'NW1 4RY',
  :country => 'GB',
  :phone => '+1 555 341 9393',
  :email => 'mrhippo@goshippo.com')

#Create parcel object
parcel = Shippo::Parcel.create(
  :length => 5,
  :width => 1,
  :height => 5.555,
  :distance_unit => :cm,
  :weight => 2,
  :mass_unit => :lb)

#example CustomsItems object. This is only required for int'l shipment only.
customs_item = Shippo::Customs_Item.create(
  :description => "T-Shirt",
  :quantity => 2,
  :net_weight => "400",
  :mass_unit => "g",
  :value_amount => "20",
  :value_currency => "USD",
  :origin_country => "US")

#Creating the CustomsDeclaration
#(CustomsDeclarations are only required for international shipments)
customs_declaration = Shippo::Customs_Declaration.create(
  :contents_type => "MERCHANDISE",
  :contents_explanation => "T-Shirt purchase",
  :non_delivery_option => "RETURN",
  :certify => true,
  :certify_signer => "Laura Behrens Wu",
  :items => customs_item["object_id"])

#Creating the shipment object. In this example, the objects are directly passed to the 
#Shipment.create method, Alternatively, the Address and Parcel objects could be created 
#using Address.create(..) and Parcel.create(..) functions respectively.
shipment = Shippo::Shipment.create(
  :object_purpose => 'PURCHASE',
  :submission_type => 'DROPOFF',
  # you can also put in the object_id directly, but this is more convenient
  :address_from => address_from,
  :address_to => address_to,
  :parcel => parcel,
  :customs_declaration => customs_declaration)

#Wait for rates to be generated
attempts = 0
while ["QUEUED","WAITING"].include? shipment.object_status  and attempts <10 do
  shipment = Shippo::Shipment.get(shipment["object_id"])
  attempts+=1
end

#Get all rates for shipment.
rates = shipment.rates()

#Get the first rate in the rates results.
rate = rates[0]

#Purchase the desired rate. sync=True indicates that the function will wait until the 
#carrier returns a shipping label before it returns
transaction = Shippo::Transaction.create(:rate => rate["object_id"])

#Wait for transaction to be proccessed
attempts = 0
while ["QUEUED","WAITING"].include? transaction.object_status and attempts <10 do
  transaction = Shippo::Transaction.get(transaction["object_id"])
  attempts+=1
end

#label_url and tracking_number
if transaction.object_status != "ERROR"
    puts transaction.label_url
    puts transaction.tracking_number
else
    puts transaction.messages
end
