#### 2.0.4 release, Oct 6th 2016
 - Rails5 Compatibility via relaxed dependencies
   - removing mime-types dependency
   - relaxing activesupport to allow version 5
 - reorganizing exceptions to enable subclassing with additional parameters and more readable #to_s method
 - adding bin/console for easy irb-ing 

#### 2.0.3 release, Oct 3rd 2016

 - Handled RestClient::BadRequest to show response content

#### 2.0.2 release, Aug 17th 2016

 - Removed gem dependency `colored2` as directly decorating object and string was causing Rals Rack to throw errors when users uploaded large files.
 - Fixed url for `CarrierAccount` 
 - README fixes
 
#### 2.0.0-beta  July 7th, 2016

 - Added a concept of List transformer in order to properly coerce
   received hashes into proper model objects
 - updated to_s and inspect on models and ApiObject
 - added a large number of new tests

####  2.0.0-alpha June, 2016

 - Library refactoring and reorganization
    - Consolidating operations under the Shippo::API::Operations namespace
    - Instead of doing `include <operation module>` using new `operations :list, :create, ... ` class methods
    - Instead of setting a global class instance variable `@custom_url`, use new class method `url "/custom/uri"` to set the custom URI component
    - Added `actievesupport` gem dependency for `#pluralize` and `#constantize` instead of rolling our own
    - Token should now be set via `Shippo::API.token =`, although `Shippo.api_token = ` is also supported
    - Renamed `Api` to `API` in line with Ruby conventions
    - Consolidated `Resource` and `ContainerObject` into one class
    - Extracted a new class `Shippo::API::Request`
    - Extracted `#validate` and `#rates` into operations
    - Created 2nd-level namspaces to separate models from operations from utility classes such as `Request` and `Resource`
    - Consolidated models under Shippo namespace
    - Converted existing unit test into an RSpec
 - Improved overall exception handling
    - split up and organized Exceptions
    - mapping TCP-specific errors to `ConnectionError`
    - mapping JSON parser and server errors
 - Improved the Example script
    - Added exception handling clause similar to how the API should be used in real life
    - Reading API token from the environment
    - Moved example script into `bin/example`
 - Miscellaneous:
    - Reformatting and updated README
    - Added a rake task for documentation generation `rake shippo:doc`
    - Added Yardoc parameters and class descriptions to key entities
    - Updated syntax for Ruby 2+
    - Renamed the gem from `shippo` to `shippo-api`.

####  1.0.4 June 19th, 2015

- added support for Carrier Accounts

#### 1.0.3 June 18th, 2015

- changed auth to use ShippoToken (vs username and password)

####  1.0.2 Aug 25th, 2014

- added optional parameter <currency> for shipment.rates()
- added validate method to address
- added manifest, customs_item, customs_declaration, and refund classes
