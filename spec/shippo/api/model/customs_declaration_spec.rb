require 'spec_helper'
RSpec.describe Shippo::CustomsDeclaration do
  context 'when class name is two words' do
    subject { Shippo::CustomsDeclaration.url }
    it { is_expected.to  eql('/customs/declarations') }
  end
end
