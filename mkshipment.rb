require 'shippo'
Shippo::api_user = 'tobias.schottdorf@gmail.com'
Shippo::api_pass = 'qPkabv42hJAs'
##p Shippo::Address.all
#p Shippo::Parcel.all
#p Shippo::Shipment.all
#p Shippo::Rate.all
#p Shippo::Transaction.all
#p Shippo::Parcel.get('06b92bde4e9846fb895cbafc00393e4d')
p Shippo::Shipment.create(
  :object_purpose => 'QUOTE',
  :address_from =>   Shippo::Address.get('57cfb658421f479eb37ae8d7da2f3038'),
  :address_to =>     '0bd6026a5d5d47229ba07fa66108084a',
  :parcel =>         Shippo::Parcel.get('341adb35e50a4895af8ac802bc4d6389'),
  :metadata =>       'Testing the API'
)
