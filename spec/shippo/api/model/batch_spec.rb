require 'dummy_helper'
require 'spec_helper'

DEFAULT_CARRIER_ACCOUNT = 'bb980a0dcd2047328024bc3dcad56682'
DEFAULT_SERVICELEVEL_TOKEN = 'usps_priority'

RSpec.describe 'Shippo::API::Batch' do
  let(:dummy_batch) { DUMMY_BATCH }

  describe '#retrieve' do
    it 'should properly return a Batch object' do
      VCR.use_cassette("batch/test_retrieve") do
        batch = Shippo::Batch::create(dummy_batch.dup)
        expect(batch).to be_kind_of(Shippo::Batch)
        expect(batch[:object_status]).to be == 'VALIDATING'
      end
    end
  end
end