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
  end

  context 'colors are no longer defined, but should work silently' do
    let(:string) { 'poopikinks' }
    it 'throws exception when colors are used without require' do
      expect { string.bold.red }.to raise_error(NoMethodError)
    end
  end
end
