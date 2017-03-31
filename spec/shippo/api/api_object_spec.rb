require 'spec_helper'
require 'shippo/api/category'
require 'shippo/api/category/state'

RSpec.describe 'Shippo::API::ApiObject' do
  let(:json) { '
       {
         "object_state":"VALID",
         "object_created":"2014-07-16T23:20:31.089Z",
         "object_updated":"2014-07-16T23:20:31.089Z",
         "object_id":"747207de2ba64443b645d08388d0309c",
         "object_owner":"shippotle@goshippo.com"
       }'
  }

  let(:hash) { JSON.load(json) }

  context '#new' do
    context 'instantiate ApiObject' do
      let(:object) { Shippo::API::ApiObject.new(hash) }
      it 'should properly initialize strings' do
        expect(object.id).to eql('747207de2ba64443b645d08388d0309c')
        expect(object.owner).to eql('shippotle@goshippo.com')
      end
      it 'should properly initialize timestamps' do
        expect(object.created).to be_a_kind_of(Time)
        expect(object.created.to_s).to eql('2014-07-16 23:20:31 UTC')
      end
      it 'should initialize categories' do
        # noinspection RubyResolve
        expect(object.state).to eql(Shippo::API::Category::State::VALID)
        expect(object.state.valid?).to be_truthy
      end
      context 'with different state' do
        before do
          hash['object_state'] = 'INVALID'
        end
        it 'should initialize categories' do
          # noinspection RubyResolve
          expect(object.state).to eql(Shippo::API::Category::State::INVALID)
          expect(object.state.valid?).to be_falsey
          expect(object.state.invalid?).to be_truthy
        end
      end
    end

  end
end
