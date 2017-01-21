require 'spec_helper'
RSpec.describe Shippo::Address do
  context 'correctly pluralize address to addresses' do
    subject { Shippo::Address.url }
    it { is_expected.to  eql('/addresses') }
  end
end

RSpec.describe Shippo::Address do
  context 'validate' do
  	v = Shippo::Address.validate('0b1fe132b4d14f5eaee4fd8d480452bc')
  	puts v.object.id
  	expect(v.object.id).to eql("c0b8bb8104bd4b67adb4bd57dd886f77")
  end
end
