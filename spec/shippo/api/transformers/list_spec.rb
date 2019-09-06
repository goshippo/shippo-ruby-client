require 'spec_helper'
require 'shippo/api/transformers/list'

RSpec.describe Shippo::API::Transformers::List do
  let(:resource) { Shippo::API::Resource.new(params.dup) }
  let(:obj_id) { 'afa9fa09fa809f98f0a' }
  let(:obj_owner) { 'shippo@shippotest.com' }
  let(:deliver_by) { Time.now }
  context 'when a value is an array' do
    let(:params) {
      {
        rates: [{ shipment: '13123' }, { shipment: '44343' }],
        parcels:    [{ object_id: obj_id, 'object_owner' => obj_owner, deliver_by: deliver_by }],
        items:      [{ pi: 3.1416926 }],
        shipments:  [{ name: 'Little House in the Fluffy Clouds', object_id: obj_id, 'object_created' => deliver_by.to_s}],
        messages:   %w(boo moo poo)
      } }

    context 'it should be automatically cast to a known class' do
      context 'from a field that ends with _list' do
        it 'should create elements of type Shippo::Rate' do
          expect(resource.rates.first).to be_kind_of(Shippo::Rate)
        end
      end
      context 'from a name that is a plular of a model, such as parcels' do
        context '#private methods' do
          let(:transform) { Shippo::API::Transformers::List.new(params[:parcels][0]) }
          it 'should be able to match by name' do
            expect(transform.send(:detect_type_name, :parcels)).to eql('parcels')
          end
          it 'should be able to match the class name' do
            expect(transform.send(:detect_type_class, 'parcels')).to eql(Shippo::Parcel)
          end
          context 'when shipping is created' do
            let(:parcel) { Shippo::Parcel.from(params[:parcels][0]) }
            it 'should be able to create new shipment from the hash' do
              expect(parcel.object.id).to eql(obj_id)
              expect(parcel.object.owner).to eql(obj_owner)
              expect(parcel.deliver_by).to eql(deliver_by)
            end
          end
        end
        it 'should still be an array' do
          # noinspection RubyResolve
          expect(resource.parcels).to_not be_nil
          expect(resource.parcels).to be_kind_of(Array)
          expect(resource.parcels.size).to eql(1)
        end
        it 'should have its members cast' do
          expect(resource.parcels.first).to be_kind_of(Shippo::Parcel)
          expect(resource.parcels.first.object).to be_kind_of(Shippo::API::ApiObject)
          expect(resource.parcels.first.deliver_by).to eql(deliver_by)
          expect(resource.parcels.first.object.owner).to eql(obj_owner)
          expect(resource.parcels.first.object.id).to eql(obj_id)
        end
      end
      context 'from a special cased enumeration like "items"' do
        it 'should still be an array' do
          # noinspection RubyResolve
          expect(resource.items).to_not be_nil
          expect(resource.items).to be_kind_of(Array)
          expect(resource.items.size).to eql(1)
        end
        it 'should have its members cast' do
          expect(resource.items.first).to be_kind_of(Shippo::CustomsItem)
          expect(resource.items.first.pi).to eql(3.1416926)
        end
      end
      context 'from a special cased enumeration like "shipments"' do
        it 'should still be an array' do
          # noinspection RubyResolve
          expect(resource.shipments).to_not be_nil
          expect(resource.shipments).to be_kind_of(Array)
          expect(resource.shipments.size).to eql(1)
        end
        it 'should have its members cast' do
          expect(resource.shipments.first).to be_kind_of(Shippo::Shipment)
          expect(resource.shipments.first.name).to eql(params[:shipments].first[:name])
        end
      end
      context 'not a resource array type' do
        it 'should remain uncoerced' do
          expect(resource.messages.first).to be_kind_of(String)
          expect(resource.messages.first).to eql('boo')
        end
      end
    end
  end
end
