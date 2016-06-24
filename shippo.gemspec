# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shippo/api/version'

Gem::Specification.new do |spec|
  spec.name                  = 'shippo-api'
  spec.version               = Shippo::API::VERSION
  spec.required_ruby_version = '>= 2.0.0'
  spec.summary               = 'API client for Shippo® APIs. Shippo helps you connect with multiple carriers (FedEx, UPS, USPS and many others) via a unified modern API'
  spec.description           = 'A gem for connecting with over 20 shipping carriers and consolidators via a single integration using Shippo API. Support for shipping rates, buying and printing labels, tracking as well as some carrier specific functionality such as signature required, adult signature confirmation, certified mail, delivery confirmation and many others.'
  spec.authors               = ['Shippo & Contributors', 'Konstantin Gredeskoul']
  spec.email                 = 'support@goshippo.com kigster@gmail.com'
  spec.files                 = %w(example.rb test/test.rb lib/shippo.rb).concat(Dir.entries('./lib/shippo/').keep_if { |v| /\.rb$/.match(v) }.collect! { |v| './lib/shippo/'+v })
  spec.homepage              = 'http://github.com/goshippo/shippo-ruby-client'
  spec.license               = 'MIT'
  spec.metadata              = { 'shippo_documentation' => 'https://goshippo.com/docs/' }

  spec.add_dependency 'rest-client', '~> 1.8'
  spec.add_dependency 'mime-types', '~> 2'
  spec.add_dependency 'json', '~> 1.8'
  spec.add_dependency 'hashie', '~> 3.4'
  spec.add_dependency 'activesupport', '~> 4'
  spec.add_dependency 'colored2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'rspec', '~> 3.4'
end
