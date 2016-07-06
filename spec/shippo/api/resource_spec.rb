require 'spec_helper'

RSpec.describe Shippo::API::Resource do
  let(:resource) { Shippo::API::Resource.new(params.dup) }
  context '#initialize' do
    let(:params) { { rates_list: [{ shipment: '13123' }, { shipment: '44343' }] } }
    context 'list of models defined as #rates_list' do
      it 'should convert array elements into model object' do
        expect(resource.rates).not_to be_nil
      end
      it 'should create elements of type Shippo::Rate' do
        expect(resource.rates.first).to be_kind_of(Shippo::Rate)
      end
      it 'should no longer have original rates_list' do
        expect(resource[:rates_list]).to be_nil
      end
    end
  end

  context '#object' do
    let(:object_id) { 'afa9fa09fa809f98f0a' }
    let(:params) { {
      rates_list:
        [{ shipment: '13123' },
         { shipment: '44343' }],
      object_id: object_id,
      object_owner: 'shippo@goshippo.com'
      } }
    context 'when object_* fields are found' do
      it 'then extracts them into an #object' do
        expect(resource.object.id).to eql(object_id)
        expect(resource.object.owner).to eql(params[:object_owner])
      end
      it 'also provides object_ accessors for backwards compatibility' do
        # noinspection RubyResolve
        expect(resource.resource_id).to eql(object_id)
        # noinspection RubyResolve
        expect(resource.object_owner).to eql(params[:object_owner])
      end
    end

  end

end
