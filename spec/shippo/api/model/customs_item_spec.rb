require 'spec_helper'
RSpec.describe Shippo::Model::CustomsItem do
  context 'when class name is two words' do
    subject { Shippo::Model::CustomsItem.url }
    it { is_expected.to  eql('/customs/items') }
  end
end
