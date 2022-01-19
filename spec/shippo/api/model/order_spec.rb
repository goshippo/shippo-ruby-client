require 'spec_helper'
require 'dummy_helper'

RSpec.describe 'Shippo::API::Order' do
  let(:dummy_order) { DUMMY_ORDER }

  describe '#create' do
    it 'should propertly create an order' do
      VCR.use_cassette("orders/test_create") do 
        order = Shippo::Order::create(dummy_order.dup)
        expect(order).to be_kind_of(Shippo::Order)
      end
    end
  end
end