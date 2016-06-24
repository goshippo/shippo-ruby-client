
# Shippo API – Ruby Wrapper for Shippo API

[![Build Status](https://travis-ci.org/kigster/shippo-ruby-client.svg?branch=master)](https://travis-ci.org/kigster/shippo-ruby-client)

[![Code Climate](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/gpa.svg)](https://codeclimate.com/github/kigster/shippo-ruby-client)

Shippo is a shipping API that connects you with multiple shipping carriers (such as USPS, UPS, DHL, Canada Post, Australia Post, UberRUSH and many [others](https://goshippo.com/shipping-carriers/)) through one interface.

Our API provides in depth support of cross-carrier functionality. Here are just some of the features we support for USPS, FedEx, UPS and many others via the API.

## Core Functionality

For most major carriers (USPS, UPS, FedEx and most others) our API supports:

* Querying for shipping rates
* Creating and printing labels
* Tracking shipments

#### Additional Features for USPS

For USPS, the API additionally supports:

  * US Address validation
  * Scan forms
  * Signature
  * Certified mail
  * Delivery confirmation
  * etc.

#### FedEx

For FedEx, the API additionally supports:

  * Signature and adult signature confirmation
  * FedEx Smartpost

### UPS

For UPS, the API additionally supports:

  * Signature and adult signature confirmation
  * UPS Mail Innovations
  * UPS SurePost

The complete list of carrier supported features is [here](https://goshippo.com/shipping-api/carriers).

### About Shippo

Connect with multiple different carriers, get discounted shipping labels, track parcels, and much more with just one integration. You can use your own carrier accounts or take advantage of our deeply discounted rates. Using Shippo makes it easy to deal with multiple carrier integrations,  rate shopping, tracking and other parts of the shipping workflow. We provide the API and dashboard for all your shipping needs.

The API is free to use. You only pay when you print a live label from a carrier.  Use test labels during development to avoid all fees.

You do need a Shippo account to use our API. Don't have an account? Sign up at [https://goshippo.com/](https://goshippo.com/).

## Installation

This library is distributed as a ruby gem, therefore youcan install it via adding the following line to your `Gemfile`:

```
gem 'shippo-api'
```

If you prefer to use the latest version of the library, just point your Gemfile to our github repo:

```
gem 'shippo-api', git: 'https://github.com/goshippo/shippo-ruby-api'
```

Or you can install the gem using the `gem` command:

```bash
gem install shippo-api
```

## Usage 

```ruby
require 'shippo/api'

Shippo::API.token = 'YOUR_PRIVATE_TOKEN'

# Create address_from hash
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

# Create address_to hash
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

# Create a parcel hash
parcel            = {
  :length        => 5,
  :width         => 2,
  :height        => 5,
  :distance_unit => :in,
  :weight        => 2,
  :mass_unit     => :lb }

hash = { :object_purpose => 'PURCHASE',
         :address_from   => address_from,
         :address_to     => address_to,
         :parcel         => parcel,
         :async          => false }
puts 'Making the first API call with the following parameters:'.bold.green.underlined
ap hash

@shipment = Shippo::Model::Shipment.create(hash)
```

Look at `bin/example` for more code samples

Version 2 and up of this gem works with Ruby 2.2 and later, and is not backwards compatible.

If you are still using an older version of Ruby, please make sure to get the latest 1.* version of this gem also.

## Documentation

Please see [https://goshippo.com/shipping-api/](https://goshippo.com/shipping-api/) for up-to-date documentation.

For Ruby class documentation, please run the following rake task:

```bash
bundle
bundle exec rake shippo:doc
```

This task will generate documentation using [Yard](https://yardoc.org) and then open the browser with the generated index.html.
