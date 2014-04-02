shippo-ruby-client
==================
A client wrapper library to access the API of http://goshippo.com.
Still under development. Feel free to contribute!
```
require 'shippo'
Shippo::api_user = 'YOUR_API_USER'
Shippo::api_pass = 'YOUR_API_PASS'

from = Shippo::Address.create(
  :object_purchase => 'QUOTE',
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
  :email => 'laura@goshippo.com',
  :ip => '',
  :metadata => 'Customer ID 123456'
)
puts from
to = Shippo::Address.create(
  :object_purchase => 'QUOTE',
  :name => 'Mr. John Doe',
  :company => 'ACME Inc.',
  :street1 => nil,
  :street_no => '',
  :street2 => '',
  :city => 'Berlin',
  :country => 'DE',
  :ip => '',
  :metadata => ''
)
puts to
parcel = Shippo::Parcel.create(
  :length => 5,
  :width => 1,
  :height => 5.555,
  :distance_unit => :cm,
  :weight => '2.122',
  :mass_unit => :lb,
  :metadata => 'Customer ID 123456'
)
puts parcel
shipment = Shippo::Shipment.create(
  :object_purpose => 'QUOTE',
  # you can also put in the object_id directly, but this is more convenient
  :address_from => from,
  :address_to => to,
  :parcel => parcel,
  :metadata => 'Quote Shipment'
)
puts shipment
# never do this in real life
sleep(5)

rates = shipment.rates

puts "Shipment #{shipment[:object_id]} has the following rates:\n\n#{rates}"
```
