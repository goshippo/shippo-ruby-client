
# Shippo API – Ruby Wrapper for Shippo API

[![Build Status](https://travis-ci.org/kigster/shippo-ruby-client.svg?branch=master)](https://travis-ci.org/kigster/shippo-ruby-client) 
[![Code Climate](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/gpa.svg)](https://codeclimate.com/github/kigster/shippo-ruby-client) 
[![Test Coverage](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/coverage.svg)](https://codeclimate.com/github/kigster/shippo-ruby-client/coverage)
[![Issue Count](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/issue_count.svg)](https://codeclimate.com/github/kigster/shippo-ruby-client)

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
gem 'shippo-api', git: 'https://github.com/goshippo/shippo-ruby-client'
```

Or you can install the gem using the `gem` command:

```bash
gem install shippo-api
```

## Usage 


```ruby
require 'shippo/api'

# Setup your API token
Shippo::API.token = '1234ABFC1234ABCFD'

# OR, equivalently (kept for backwards compatibility)
Shippo.api_key = '1234ABFC1234ABCFD'

# Setup query parameter hash
params   = { object_purpose: 'PURCHASE',
              async:          false,
              address_from:   {
                object_purpose: 'PURCHASE',
                name:           'Mr Hippo',
                company:        'Shippo',
                street1:        '215 Clayton St.',
                street2:        '',
                city:           'San Francisco',
                state:          'CA',
                zip:            '94117',
                country:        'US',
                phone:          '+1 555 341 9393',
                email:          'support@goshippo.com' },
              address_to:     {
                object_purpose: 'PURCHASE',
                name:           'Mrs Hippo"',
                company:        'San Diego Zoo',
                street1:        '2920 Zoo Drive',
                city:           'San Diego',
                state:          'CA',
                zip:            '92101',
                country:        'US',
                phone:          '+1 555 341 9393',
                email:          'hippo@goshippo.com' },
              parcel:         {
                length:        5,
                width:         2,
                height:        5,
                distance_unit: :in,
                weight:        2,
                mass_unit:     :lb }
}

# Make our API call 
@shipment = Shippo::Model::Shipment.create(params)

```

### Using Provided Example File

Look at `bin/example` for more code sample.

You can actually run this file, but first you should set your API token in the environment:

```bash
export SHIPPO_API_TOKEN="<your token here>"
bin/example
```

## Gem Versioning Notes

Version 2 and up of this library works with Ruby 2.2 and later, and is not backwards compatible. Starting version 2, the gem has been renamed to `shippo-api` to further emphasize changes in the library. __Version 1.0.4__ of this library is the last version of the gem `shippo`, and the last version supporting ruby 1.8 and 1.9.

The intent, however, is to completely deprecate `shippo` gem in the near future.

### If you are still using Ruby 1.8 or 1.9

If you are still using an older version of Ruby, please make sure to use the last 1.X version of this library, which is currently the [tag v1.0.4](https://github.com/goshippo/shippo-ruby-client/tree/v1.0.4).

## Documentation

Please see [https://goshippo.com/shipping-api/](https://goshippo.com/shipping-api/) for up-to-date documentation.

For Ruby class documentation, please run the following rake task:

```bash
bundle install
bundle exec rake doc:read # preview documentation in the browser
```

This task will generate documentation using [Yard](https://yardoc.org) and then open the browser with the generated index.html.
