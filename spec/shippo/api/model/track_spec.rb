require 'spec_helper'

RSpec.describe 'Shippo::API::Track' do
  context 'you have a tracking number from a certain carrier' do
    it 'should return you the status of the shipment' do
      Shippo::Track.track.get('usps', '9205590164917337534322')
    end
  end
end
