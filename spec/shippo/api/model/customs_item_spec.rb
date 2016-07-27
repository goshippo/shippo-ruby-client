require 'spec_helper'
RSpec.describe Shippo::CustomsItem do
  context 'when class name is two words' do
    subject { Shippo::CustomsItem.url }
    it { is_expected.to  eql('/customs/items') }
  end
end
