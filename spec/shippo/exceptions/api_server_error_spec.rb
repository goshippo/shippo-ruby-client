require 'spec_helper'
module Shippo
  module Exceptions

    RSpec.describe APIServerError do
      let(:http_response) { '401 Super Bad' }

      let(:response) {
        %q={"address_from": [{"country": ["Invalid value specified for country 'USSSSSS'"]}]}=
      }

      let(:request) {
        ::Shippo::API::Request.new(
          method: :get,
          uri:    '/address',
          params: { object_id: 1 })
      }

      let(:error) { APIServerError.new('Bad things are happening',
                                       request, response, http_response) }

      context '#new' do
        it 'should have all members set' do
          expect(error.request).to eql(request)
          expect(error.response).to eql(response)
          expect(error.http_response_message).to eql(http_response)
        end
      end

      context '#to_s' do
        context 'should include both subclass and superclass members' do
          subject { error.to_s }
          it { is_expected.to_not be_nil }
          it { is_expected.to match /response:/m}
          it { is_expected.to match /401 Super Bad/m}
          it { is_expected.to match /http_response_message:/m}
        end
      end

    end
  end
end
