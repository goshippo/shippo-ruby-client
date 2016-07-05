require 'spec_helper'

RSpec.describe Shippo::API::Resource do
  let(:param) { { rates_list: [{ shipment: '13123' }, { shipment: '44343' }] } }

  context '#initialize' do
    let(:resource) { Shippo::API::Resource.new(param) }
    context 'list of models defined as #rates_list' do
      it 'should convert array elements into model object' do
        expect(resource.rates).not_to be_nil
      end
      it 'should create elements of type Shippo::Model::Rate' do
        expect(resource.rates.first).to be_kind_of(Shippo::Model::Rate)
      end
      it 'should no longer have original rates_list' do
        expect(resource[:rates_list]).to be_nil
      end
    end
  end

end
