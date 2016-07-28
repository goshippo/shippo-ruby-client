
# Shippo API – Ruby Wrapper for Shippo API

[![Build Status](https://travis-ci.org/kigster/shippo-ruby-client.svg?branch=master)](https://travis-ci.org/kigster/shippo-ruby-client)
[![Code Climate](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/gpa.svg)](https://codeclimate.com/github/kigster/shippo-ruby-client)
[![Test Coverage](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/coverage.svg?refresh=1)](https://codeclimate.com/github/kigster/shippo-ruby-client/coverage)
[![Issue Count](https://codeclimate.com/github/kigster/shippo-ruby-client/badges/issue_count.svg?refresh=1)](https://codeclimate.com/github/kigster/shippo-ruby-client)

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
gem 'shippo'
```

If you prefer to use the latest version of the library, just point your Gemfile to our github repo:

```
gem 'shippo', git: 'https://github.com/goshippo/shippo-ruby-client'
```

Or you can install the gem using the `gem` command:

```bash
gem install shippo
```

## Usage


```ruby
require 'shippo/api'

# Setup your API token
Shippo.api_key = 'aff988f77afa0fdfdfadf'  # not an actual valid token

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
@shipment = Shippo::Shipment.create(params)
@shipment.success?
# => true
@shipment.object.status
# => 'SUCCESS'
@shipment.status # forwarded to #object
# => 'SUCCESS'
@shipment.state
# => 'VALID'
```

Let's take a quick look at what the `Shipment` object looks like:

```ruby
require 'awesome_print'
ap @shipment
# {
#        "carrier_accounts" => [],
#            "address_from" => "a704eada7494bb1be6184ef64b1646db",
#              "address_to" => "92b43fbfa3641644beb32996042eb57a",
#          "address_return" => "a1f64ba14b7e41b86a0446de4ebbd769",
#                  "parcel" => "92df4baac73ea6131940c0d315d70a7d",
#         "submission_date" => "2016-07-06T20:33:02.211Z",
#               "return_of" => nil,
#     "customs_declaration" => nil,
#        "insurance_amount" => "0",
#      "insurance_currency" => nil,
#                   "extra" => {},
#             "reference_1" => "",
#             "reference_2" => "",
#               "rates_url" => "https://api.goshippo.com/v1/shipments/a336daf87a8e442992a68daa6622758f/rates/",
#                "messages" => [ ] # ommitted for brevity,
#              "rates_list" => [ ] # ommitted for brevity.
# }
```

#### List Handling

In the case when the API returns a hash with one of the hash values being an array of entities, and if the corresponding key can be mapped into one of the existing API models, then each of the members of the array is coerced from a hash into an object of the model's type.

In the example below we are showing the result of such transformation where the `rates_list` contains a list of fully constructed objects of type `Shippo::Rate` after being coerced from a hash.

```ruby
ap @shipment.rates_list.first
# =>
# {
#                     "shipment" => "20f25e44b16b4051b6dd910cb66fd27b",
#             "available_shippo" => true,
#                   "attributes" => [],
#                       "amount" => "8.51",
#                     "currency" => "USD",
#                 "amount_local" => "8.51",
#               "currency_local" => "USD",
#                     "provider" => "FedEx",
#            "provider_image_75" => "https://shippo-static.s3.amazonaws.com/providers/75/FedEx.png",
#           "provider_image_200" => "https://shippo-static.s3.amazonaws.com/providers/200/FedEx.png",
#            "servicelevel_name" => "Ground",
#           "servicelevel_token" => "fedex_ground",
#           "servicelevel_terms" => "",
#                         "days" => 2,
#                   "arrives_by" => nil,
#               "duration_terms" => "",
#                    "trackable" => true,
#                    "insurance" => false,
#       "insurance_amount_local" => "0.00",
#     "insurance_currency_local" => nil,
#             "insurance_amount" => "0.00",
#           "insurance_currency" => nil,
#            "delivery_attempts" => nil,
#            "outbound_endpoint" => "door",
#             "inbound_endpoint" => "door",
#                     "messages" => [],
#              "carrier_account" => "4b1940bc69524163b669asd361842db",
#                         "test" => true
# }
@shipment.rates.first.owner
# ⤷ unittest@gmail.com
@shipment.rates.first.class
# ⤷ Shippo::Rate
```

#### Resource ID and Other Object Fields

Shippo API returns several generalized fields for each valid resource, that being with 'object_' – for example, `object_id`, `object_owner`, etc.  In this library we move these fields out of the main model, and into an instance of `Shippo::API::ApiObject`. However the fields can still be accessed on the main model via generated accessors.

Unfortunately Shippo API also returns `object_id`, which in Ruby has a special meaning: it's the pointer address of any object. Overwriting this field causes all sorts of issues.

For this reason we are mapping `object_id` to `resource_id`, as soon as the hash is passed in to initialize `ApiObject`.

The following console output demonstrates many ways of accessing `object_` fields:

```ruby
@shipment.object_id    # this is the Ruby object pointer
# ⤷ 70206221831520  
@shipment.resource_id  # this is the API id (note: deprecated accessor)
# ⤷ 20f25e44b16b4051b6dd910cb66fd27b
@shipment.object.id    # which is actually just this
# ⤷ 20f25e44b16b4051b6dd910cb66fd27b
@shipment.id           # but it can also be accessed this way too
# ⤷ 20f25e44b16b4051b6dd910cb66fd27b
```

And with the rest of the `object_` fields:

``` ruby
@shipment.object.owner    # this is whether 'object_owner' is stored
# ⤷ valued_customer@gmail.com
@shipment.object_owner    # deprecated accessor method
# ⤷ valued_customer@gmail.com
@shipment.owner           # forwarded alias to #object.owner
# ⤷ valued_customer@gmail.com
```

Here is the fully construted `ApiObject` instance, attached to our `@shipment`:

```ruby
ap @shipment.object
# {
#     :created => 2016-07-06 20:44:47 UTC,
#     :updated => 2016-07-06 20:44:47 UTC,
#       :owner => "valued_customer@gmail.com",
#       :state => #<Shippo::API::Category::State:0x007fd88be8aa38 @name=:state, @value=:valid>,
#      :status => #<Shippo::API::Category::Status:0x007fd88be82e28 @name=:status, @value=:success>,
#     :purpose => #<Shippo::API::Category::Purpose:0x007fd88be985e8 @name=:purpose, @value=:purchase>,
#          :id => "20f25e44b16b4051b6dd910cb66fd27b"
# }
```

#### Validation

In general this gem does not currently perform validation, *except* in the cases when enumerations are used. The gem automatically converts a response containing keys matching one of the known categories (such as `Shippo::API::Category::Status` and it's value into one of the constants, such as `SUCCESS`.

### Using Provided Example File

Look at `bin/example` for more code sample.

You can actually run this file, but first you should set your API token in the environment:

```bash
export SHIPPO_TOKEN="<your token here>"
bin/example
```

## Gem Versioning Notes

Version 2 and up of this library works with Ruby 2.2 and later, and is not backwards compatible. __Version 1.0.4__ of this library is the last version of the gem `shippo`, and the last version supporting ruby 1.8 and 1.9.

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
