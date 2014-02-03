require 'dir'
Gem::Specification.new do |s|
  s.name        = 'shippo'
  s.version     = '0.0.1'
  s.date        = '2014-02-03'
  s.summary     = "Shippo API"
  s.description = "Quick and easy access to the Shippo API"
  s.authors     = ["Tobias Schottdorf"]
  s.email       = 'tobias.schottdorf@gmail.com'
  s.files       = ["example.rb", "test/test.rb", "lib/shippo.rb"].concat(Dir.entries('./lib/shippo/').keep_if { |v| /\.rb$/.match(v) }.collect! { |v| './lib/shippo/'+v })
  s.homepage    = 'http://goshippo.com'
  s.license       = 'MIT'
  puts s
end
