require 'spec_helper'
require 'vcr'

CARRIER = 'usps'
TRACKING_NO = '9205590164917312751089'

RSpec.describe 'Shippo::API::Track' do
  VCR.configure do |config|
    config.filter_sensitive_data('<API_TOKEN>') do |interaction|
      interaction.request.headers['Authorization'].first
    end
    config.cassette_library_dir = 'spec/fixtures/track'
    config.hook_into :webmock
  end

  describe '#retrieve' do
    it 'should properly return tracking status' do
      VCR.use_cassette("test_retrieve") do
        track = Shippo::Track::get_with_carrier(TRACKING_NO, CARRIER)
        expect(track).to be_kind_of(Shippo::Track)
        expect(track.tracking_number).to be == TRACKING_NO
        expect(track.tracking_history).not_to be == nil
      end
    end
  end

  describe '#invalid_retrieve' do
    it 'should raise an exception' do
      VCR.use_cassette("test_invalid_retrieve") do
        expect {
          Shippo::Track::get_with_carrier("INVALID_NO", CARRIER)
        }.to raise_error(Shippo::Exceptions::ConnectionError)
      end
    end
  end
end