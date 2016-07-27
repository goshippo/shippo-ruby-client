require 'spec_helper'
require 'shippo/api/category'
require 'shippo/api/category/base'

RSpec.describe 'Shippo::API::Category::Base' do
  class BooMoo < Shippo::API::Category::Base
    allowed_values :boo, :moo, :doo
    # Generates:
    # BOO = BooMoo.new(:boo)
    # MOO = BooMoo.new(:moo)
    # DOO = BooMoo.new(:doo)
  end
  let(:value) { :doo }
  let(:doo_instance) {
    BooMoo.new(value)
  }
  it 'should have a BOO constant defined ' do
    expect(doo_instance.class.const_get(:BOO)).to_not be_nil
  end

  context 'when a constant is already created, and we instantiate another' do
    subject { BooMoo.new(:boo) }
    it { is_expected.to  eql(doo_instance.class.const_get(:BOO)) }
  end

  it 'should have correct name' do
    expect(doo_instance.value).to eql(:doo)
  end
  it 'should have correct category' do
    expect(doo_instance.name).to eql(:boomoo)
  end
  it 'should have correct #to_s' do
    expect(doo_instance.to_s).to eql('DOO')
  end

end
