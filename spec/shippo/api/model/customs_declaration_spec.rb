require 'spec_helper'
RSpec.describe Shippo::Model::CustomsDeclaration do
  context 'when class name is two words' do
    subject { Shippo::Model::CustomsDeclaration.url }
    it { is_expected.to  eql('/customs/declarations') }
  end
end
