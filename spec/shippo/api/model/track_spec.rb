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
        track.tracking_number.should == TRACKING_NO
        track.tracking_history.should_not == nil
      end
    end
  end
end