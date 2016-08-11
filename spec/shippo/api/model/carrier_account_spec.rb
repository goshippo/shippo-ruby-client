require 'spec_helper'
RSpec.describe Shippo::CarrierAccount do
  context 'is mapped to an underscore URL' do
    subject { Shippo::CarrierAccount.url }
    it { is_expected.to  eql('/carrier_accounts') }
  end
end
