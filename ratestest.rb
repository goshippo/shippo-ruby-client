require 'shippo'
Shippo::api_user = 'tobias.schottdorf@gmail.com'
Shippo::api_pass = 'qPkabv42hJAs'
shipment = Shippo::Shipment.get("b7986b902d76484a94280adaa8d40596")
#p shipment
p shipment.rates
#p shipment.rates({ :page => 2 })
