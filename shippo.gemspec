# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shippo/api/version'

Gem::Specification.new do |spec|
  spec.name                  = 'shippo'
  spec.version               = Shippo::API::VERSION
  spec.required_ruby_version = '>= 2.0.0'
  spec.summary               = 'API client for Shippo® APIs. Shippo helps you connect with multiple carriers (FedEx, UPS, USPS and many others) via a unified modern API'
  spec.description           = 'A gem for connecting with over 20 shipping carriers and consolidators via a single integration using Shippo API. Support for shipping rates, buying and printing labels, tracking as well as some carrier specific functionality such as signature required, adult signature confirmation, certified mail, delivery confirmation and many others.'
  spec.authors               = ['Shippo & Contributors', 'Konstantin Gredeskoul']
  spec.email                 = %w(support@goshippo.com kigster@gmail.com)
  spec.files                 =  `git ls-files`.split($\).reject{ |f| f.match(%r{^(doc|spec)/}) }
  spec.homepage              = 'http://github.com/goshippo/shippo-ruby-client'
  spec.license               = 'MIT'
  spec.metadata              = { 'shippo_documentation' => 'https://goshippo.com/docs/' }

  spec.add_dependency 'rest-client', '>= 2.0'
  spec.add_dependency 'json', '~> 1.8'
  spec.add_dependency 'hashie', '>= 3.5.2'
  spec.add_dependency 'activesupport', '>= 4'
  spec.add_dependency 'awesome_print'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'webmock', '~> 2.1'
  spec.add_development_dependency 'vcr', '~> 3.0', '>= 3.0.3'
end
