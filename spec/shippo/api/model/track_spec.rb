require 'spec_helper'

RSpec.describe 'Shippo::API::Track' do
  let(:params) { { 'carrier': CARRIER,
                   'tracking_number': TRACKING_NO }}

  let(:invalid_params) { { 'carrier': "INVALID_CARRIER",
                   'tracking_number': TRACKING_NO }}

  describe '#retrieve' do
    it 'should properly return a Track object' do
      VCR.use_cassette("track/test_retrieve") do
        track = Shippo::Track::get(TRACKING_NO, CARRIER)
        expect(track).to be_kind_of(Shippo::Track)
        expect(track.tracking_number).to be == TRACKING_NO
        expect(track.tracking_history).not_to be == nil
        expect(track.tracking_history.last[:status]).to be == 'TRANSIT'
      end
    end
  end

  describe '#invalid_retrieve' do
    it 'should raise an exception' do
      VCR.use_cassette("track/test_invalid_retrieve") do
        expect {
          Shippo::Track::get(TRACKING_NO, "INVALID_CARRIER")
        }.to raise_error(Shippo::Exceptions::Error)
      end
    end
  end

  describe '#register_webhook' do
    it 'should properly return a Track object' do
      VCR.use_cassette("track/test_register_webhook") do
        track = Shippo::Track::create(params.dup)
        expect(track).to be_kind_of(Shippo::Track)
        expect(track.tracking_number).to be == TRACKING_NO
        expect(track.tracking_history).not_to be == nil
        expect(track.tracking_history.last[:status]).to be == 'TRANSIT'
      end
    end
  end

  describe '#invalid_register_webhook' do
    it 'should raise an exception' do
      VCR.use_cassette("track/test_invalid_register_webhook") do
        expect {
          Shippo::Track::create(invalid_params.dup)
        }.to raise_error(Shippo::Exceptions::APIServerError)
      end
    end
  end
end
