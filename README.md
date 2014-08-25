shippo-ruby-client
==================
A client wrapper library to access the API of http://goshippo.com.
Still under development. Feel free to contribute!

The gems you'll need are:
    Rest Client
    Mocha (For Testing)
    
```ruby
require 'shippo'
Shippo::api_user = 'YOUR_API_USER'
Shippo::api_pass = 'YOUR_API_PASS'

from = Shippo::Address.create(
  :object_purpose => 'QUOTE',
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
```
Look at example.rb for more code samples
