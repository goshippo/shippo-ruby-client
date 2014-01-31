require './shippo.rb'
p Shippo::Address.all
p Shippo::Parcel.all
p Shippo::Shipment.all
p Shippo::Rate.all
p Shippo::Transaction.all
#p Shippo::Parcel.get('06b92bde4e9846fb895cbafc00393e4d')
#Shippo::Parcel.create(
#  :length => 1.5,
#  :width => 3,
#  :height => 3.141259,
#  :distance_unit => 'cm',
#  :weight => 2,
#  :weight_unit => 'kg',
#  :metadata => 'testing the api'
#)
