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
end
