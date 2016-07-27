require 'spec_helper'

RSpec.describe 'Shippo::API::Shipment' do
  let(:params) { { object_id:     'afa9fa09fa809f98f0a',
                   'object_owner' => 'shippo@shippotest.com',
                   deliver_by:    Time.now.to_s } }

  let(:shipment) { Shippo::Shipment.from(params.dup) }

  describe '#from' do
    it 'should propertly initialize self and ApiObject' do
      expect(shipment).to be_kind_of(Shippo::Shipment)
      expect(shipment.object.owner).to eql('shippo@shippotest.com')
      expect(shipment.object.owner).to eql(shipment.owner)
      expect(shipment.id).to eql(params[:object_id])
    end
  end
end
