shippo-ruby-client
==================
Shippo is a shipping API that connects you with multiple shipping carriers (such as USPS, UPS, Fedex, and DHL Express) all through one interface and allows you to create shipping labels. Shippo also offers you great discounts for US and international shipping rates.

Don't have an account? Sign up at https://goshippo.com/

Feel free to contribute!

Install
-------

Add this line to your Gemfile:

```
  gem 'shippo-ruby'
```

The gems you'll need are:
    Rest Client
    Mocha (For Testing)

```ruby
require 'shippo'
Shippo::api_token = 'YOUR_PRIVATE_KEY'

from = Shippo::Address.create(
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
  :email => 'laura@goshippo.com',
  :ip => '',
  :metadata => 'Customer ID 123456'
)
puts from
```
Look at example.rb for more code samples
