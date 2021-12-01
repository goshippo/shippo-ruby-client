require 'spec_helper'
require 'dummy_helper'
RSpec.describe Shippo::Address do
  let(:dummy_address_us) { DUMMY_ADDRESS_US }

  context 'correctly pluralize address to addresses' do
    subject { Shippo::Address.url }
    it { is_expected.to  eql('/addresses') }
  end

  it 'should properly create an address' do
    VCR.use_cassette("address/test_create") do
      address = Shippo::Address::create(dummy_address_us.dup)
      expect(address).to be_kind_of(Shippo::Address)
      expect(address[:is_complete]).to eq(true)
    end
  end
end
