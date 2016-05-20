Gem::Specification.new do |s|
  s.name        = 'shippo'
  s.version     = '1.0.4'
  s.date        = '2015-06-19'
  s.summary     = "Connect with multiple carriers (FedEx, UPS, USPS and others) via a single API with Shippo"
  s.description = "A gem for connecting with over 20 shipping carriers and consolidators via a single integration using Shippo API. Support for shipping rates, buying and printing labels, tracking as well as some carrier specific functionality such as signature required, adult signature confirmation, certified mail, delivery confirmation and many others."
  s.add_dependency('rest-client', '~> 1.4')
  s.add_dependency('mime-types', '>= 1.25', '< 3.0')
  s.add_dependency('json', '~> 1.8.1')
  s.authors     = ["Shippo & Contributors"]
  s.email       = 'support@goshippo.com'
  s.files       = ["example.rb", "test/test.rb", "lib/shippo.rb"].concat(Dir.entries('./lib/shippo/').keep_if { |v| /\.rb$/.match(v) }.collect! { |v| './lib/shippo/'+v })
  s.homepage    = 'http://goshippo.com'
  s.license     = 'MIT'
  s.metadata = { “shippo_documentation” => "https://goshippo.com/docs/" }
end
