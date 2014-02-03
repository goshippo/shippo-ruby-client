require 'shippo'
Shippo::api_user = 'tobias.schottdorf@gmail.com'
Shippo::api_pass = 'qPkabv42hJAs'
#p Shippo::Address.all
#p Shippo::Parcel.all
#p Shippo::Shipment.all
#p Shippo::Rate.all
#p Shippo::Transaction.all
#p Shippo::Parcel.get('06b92bde4e9846fb895cbafc00393e4d')
p Shippo::Parcel.create(
  :length => 1.5,
  :width => 3,
  :height => 3.1412,
  :distance_unit => 'cm',
  :weight => 2,
  :mass_unit => 'kg',
  :metadata => 'testing the api'
)
