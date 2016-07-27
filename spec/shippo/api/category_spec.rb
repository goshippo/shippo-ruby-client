require 'spec_helper'
require 'shippo/api/category'
require 'shippo/api/category/state'

RSpec.describe 'Shippo::API::Category' do
  let(:field) { 'state' }
  let(:value) { 'VALID' }
  let(:c) { Shippo::API::Category }
  context '#for_category' do
    it 'should fetch the category and the value constant' do
      expect(c.for(field, value)).to_not be_nil
    end
    it 'should fetch the category and the value constant' do
      # noinspection RubyResolve
      expect(c.for(field, value)).to eql(Shippo::API::Category::State::VALID)
    end
  end
end
