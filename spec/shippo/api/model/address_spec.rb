require 'spec_helper'
RSpec.describe Shippo::Address do
  context 'correctly pluralize address to addresses' do
    subject { Shippo::Address.url }
    it { is_expected.to  eql('/addresses') }
  end
end
