require 'spec_helper'
RSpec.describe Shippo::API do
  let(:now) { Time.now.to_i }
  let(:params) { { page: 1 } }
  let(:headers) { { 'Last-Modified' => now } }

  %i(get put post).each do |method|
    context "##{method}" do
      it 'should properly route to the #request method' do
        expect(Shippo::API).to receive(:request).with(method, '/test', params, headers).once
        Shippo::API.send(method, '/test', params, headers)
      end
    end
  end

  context 'api url definition' do
    it 'api base url should have no trailing slash' do
      expect(Shippo::API.base[-1]).not_to eql('/')
    end
  end    

  context 'api token' do
    before do
      Shippo::API.token = nil
    end
    it 'should set api token via Shippo.api_token=' do
      Shippo.api_token = 1
      expect(Shippo::API.token).to eql(1)
    end
    it 'should set api token via Shippo.api_key=' do
      Shippo.api_key = 0xFF
      expect(Shippo::API.token).to eql(0xFF)
    end
    it 'should set api token via Shippo.api_key(value)' do
      Shippo.api_key 'XYZ'
      expect(Shippo::API.token).to eql('XYZ')
    end
    it 'should allow setting temporary token' do
      Shippo::API.with_token('XYZ') { expect(Shippo::API.token).to eql('XYZ') }
      expect(Shippo::API.token).to be_nil
    end
    it 'should allow setting temporary token when token is already set' do
      Shippo.api_token = 1
      Shippo::API.with_token('XYZ') { expect(Shippo::API.token).to eql('XYZ') }
      expect(Shippo::API.token).to eql(1)
    end
  end

  context 'open timeout' do
    it 'should have default open timeout of 15' do
      expect(Shippo::API.open_timeout).to eq(15)
    end

    it 'should set open timeout via Shippo::API.open_timeout=' do
      open_timeout = 1
      Shippo::API.open_timeout = open_timeout
      expect(Shippo::API.open_timeout).to eql(open_timeout)
    end
  end

  context 'read timeout' do
    it 'should have default read timeout of 30' do
      expect(Shippo::API.read_timeout).to eq(30)
    end

    it 'should set read timeout via Shippo::API.read_timeout=' do
      read_timeout = 1
      Shippo::API.read_timeout = read_timeout
      expect(Shippo::API.read_timeout).to eql(read_timeout)
    end
  end

  context 'colors are no longer defined, but should work silently' do
    let(:string) { 'poopikinks' }
    it 'throws exception when colors are used without require' do
      expect { string.bold.red }.to raise_error(NoMethodError)
    end
  end
end
