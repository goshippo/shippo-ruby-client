Gem::Specification.new do |s|
  s.name        = 'shippo'
  s.version     = '1.0.3'
  s.date        = '2014-08-23'
  s.summary     = "Shippo API"
  s.description = "Quick and easy access to the Shippo API"
  s.add_dependency('rest-client', '~> 1.4')
  s.add_dependency('mime-types', '>= 1.25', '< 3.0')
  s.add_dependency('json', '~> 1.8.1')
  s.authors     = ["Shippo & Contributors"]
  s.email       = 'support@goshippo.com'
  s.files       = ["example.rb", "test/test.rb", "lib/shippo.rb"].concat(Dir.entries('./lib/shippo/').keep_if { |v| /\.rb$/.match(v) }.collect! { |v| './lib/shippo/'+v })
  s.homepage    = 'http://goshippo.com'
  s.license     = 'MIT'
end
