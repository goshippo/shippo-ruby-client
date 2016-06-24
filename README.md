# Shippo API – Ruby Wrapper for Shippo API

[![Build Status](https://travis-ci.org/kigster/shippo-ruby-client.svg?branch=master)](https://travis-ci.org/kigster/shippo-ruby-client)

Shippo is a shipping API that connects you with multiple shipping carriers (such as USPS, UPS, DHL, Canada Post, Australia Post, UberRUSH and many [others](https://goshippo.com/shipping-carriers/)) through one interface.

Our API provides in depth support of carrier functionality. Here are just some of the features we support for USPS, FedEx and UPS via the API.

For most major carriers (USPS, UPS, FedEx and most others) our API supports:

* Shipping rates & labels
* Tracking
	
* For USPS, the API additionally supports:
	* US Address validation
	* Scan forms
	* Additional services: signature, certified mail, delivery confirmation, and others

* For FedEx, the API additionally supports:
	* Signature and adult signature confirmation
	* FedEx Smartpost

* For UPS, the API additionally supports:
	* Signature and adult signature confirmation
	* UPS Mail Innovations
	* UPS SurePost

The complete list of carrier supported features is [here](https://goshippo.com/shipping-api/carriers).

## About Shippo
Connect with multiple different carriers, get discounted shipping labels, track parcels, and much more with just one integration. You can use your own carrier accounts or take advantage of our deeply discounted rates. Using Shippo makes it easy to deal with multiple carrier integrations,  rate shopping, tracking and other parts of the shipping workflow. We provide the API and dashboard for all your shipping needs.

The API is free to use. You only pay when you print a live label from a carrier.  Use test labels during development to avoid all fees.

You do need a Shippo account to use our API. Don't have an account? Sign up at [https://goshippo.com/](https://goshippo.com/).

## Install


Add this line to your Gemfile:

```ruby
require 'shippo'

Shippo::Api.token = 'YOUR_PRIVATE_TOKEN'

# Create address_from object
address_from      = {
  :object_purpose => 'PURCHASE',
  :name           => 'Mr Hippo',
  :company        => 'Shippo',
  :street1        => '215 Clayton St.',
  :street2        => '',
  :city           => 'San Francisco',
  :state          => 'CA',
  :zip            => '94117',
  :country        => 'US',
  :phone          => '+1 555 341 9393',
  :email          => 'support@goshippo.com' }

# Create address_to object
address_to        = {
  :object_purpose => 'PURCHASE',
  :name           => 'Mrs Hippo"',
  :company        => 'San Diego Zoo',
  :street1        => '2920 Zoo Drive',
  :city           => 'San Diego',
  :state          => 'CA',
  :zip            => '92101',
  :country        => 'US',
  :phone          => '+1 555 341 9393',
  :email          => 'hippo@goshippo.com' }

# Create parcel object
parcel            = {
  :length        => 5,
  :width         => 2,
  :height        => 5,
  :distance_unit => :in,
  :weight        => 2,
  :mass_unit     => :lb }

# First API call
shipment = Shippo::Model::Shipment.create(
  :object_purpose => 'PURCHASE',
  :address_from   => address_from,
  :address_to     => address_to,
  :parcel         => parcel,
  :async          => false)
```

Look at example.rb for more code samples

This gem has been tested with Ruby 1.8 and 2.2.

## Documentation

Please see [https://goshippo.com/shipping-api/](https://goshippo.com/shipping-api/) for up-to-date documentation.
