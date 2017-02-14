require 'dummy_helper'
require 'spec_helper'

DEFAULT_CARRIER_ACCOUNT = 'bb980a0dcd2047328024bc3dcad56682'
DEFAULT_SERVICELEVEL_TOKEN = 'usps_priority'

RSpec.describe 'Shippo::API::Batch' do
  let(:dummy_batch) { DUMMY_BATCH }

  describe '#create' do
    it 'should properly create and return a Batch object' do
      VCR.use_cassette('batch/test_create') do
        batch = Shippo::Batch::create(dummy_batch.dup)
        expect(batch).to be_kind_of(Shippo::Batch)
        expect(batch[:object_status]).to be == 'VALIDATING'
      end
    end
  end

  describe '#retrieve' do
    it 'should properly return a Batch object' do
      VCR.use_cassette('batch/test_retrieve') do
        batch = Shippo::Batch::create(dummy_batch.dup)
        retrieve = Shippo::Batch::get(batch[:object_id])
        expect(retrieve).to be_kind_of(Shippo::Batch)
        expect(retrieve).to be == batch
      end
    end
  end

  describe '#invalid_retrieve' do
    it 'should raise an error' do
      VCR.use_cassette('batch/test_invalid_retrieve') do
        expect {
          batch = Shippo::Batch::get("INVALID_ID")
        }.to raise_error(Shippo::Exceptions::Error)
      end
    end
  end
end