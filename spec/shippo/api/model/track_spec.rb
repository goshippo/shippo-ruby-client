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

  let(:params) { { 'carrier': CARRIER,
                   'tracking_number': TRACKING_NO }}

  describe '#retrieve' do
    it 'should properly return a Track object' do
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

  describe '#register_webhook' do
    it 'should properly return a Track object' do
      VCR.use_cassette("test_register_webhook") do
        track = Shippo::Track::create(params.dup)
        expect(track).to be_kind_of(Shippo::Track)
        expect(track.tracking_number).to be == TRACKING_NO
        expect(track.tracking_history).not_to be == nil
      end
    end
  end
end