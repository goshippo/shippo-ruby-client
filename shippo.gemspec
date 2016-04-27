Gem::Specification.new do |s|
  s.name        = 'shippo'
  s.version     = '1.0.4'
  s.date        = '2015-06-19'
  s.summary     = "Shippo API"
  s.description = "Shipping API library (USPS, FedEx, UPS and more) "
  s.add_dependency('rest-client', '~> 1.4')
  s.add_dependency('mime-types', '>= 1.25', '< 3.0')
  s.add_dependency('json', '~> 1.8.1')
  s.authors     = ["Shippo & Contributors"]
  s.email       = 'support@goshippo.com'
  s.files       = ["example.rb", "test/test.rb", "lib/shippo.rb"].concat(Dir.entries('./lib/shippo/').keep_if { |v| /\.rb$/.match(v) }.collect! { |v| './lib/shippo/'+v })
  s.homepage    = 'http://goshippo.com'
  s.license     = 'MIT'
end
