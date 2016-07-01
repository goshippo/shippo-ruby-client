require 'spec_helper'
require 'shippo/api/category'
require 'shippo/api/category/state'

RSpec.describe 'Shippo::API::Category::State' do
  let(:state) { Shippo::API::Category::State }
  let(:valid_state) { Shippo::API::Category::State::VALID }
  let(:also_valid_state) { Shippo::API::Category.for(:state, :valid) }

  context 'when using a dynamic constant' do
    subject { state.const_get(:VALID) }
    it { is_expected.to_not be_nil }
    it { is_expected.to eql( valid_state ) }
  end

  context 'when asking via Category#category_for' do
    subject { Shippo::API::Category.for('state', 'valid') }
    it { is_expected.to eql( valid_state )}
  end

  context 'when instantiating a category' do
    subject { Shippo::API::Category::State.new(:valid) }
    it 'should be eql to the constant' do
      is_expected.to eql(valid_state)
    end
    it 'should be eql to the return from #for' do
      is_expected.to eql(also_valid_state)
    end
    it 'should be === to the constant' do
      expect(subject === valid_state).to_not be_truthy
    end
    it 'should NOT be equal() which requires object identity' do
      is_expected.to_not equal(valid_state)
    end
  end
end
