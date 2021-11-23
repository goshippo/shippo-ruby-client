require 'spec_helper'

RSpec.describe 'Shippo::API::Order' do
  let(:params) do
    { object_id: 'afa9fa09fa809f98f0a', object_owner: 'shippo@shippotest.com' }
  end

  let(:order) { Shippo::Order.from(params.dup) }

  describe '#from' do
    it 'should propertly initialize self and ApiObject' do
      expect(order).to be_kind_of(Shippo::Order)
      expect(order.object.owner).to eql('shippo@shippotest.com')
      expect(order.object.id).to eql('afa9fa09fa809f98f0a')
    end
  end
end
