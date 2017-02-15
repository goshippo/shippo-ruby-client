require 'dummy_helper'
require 'spec_helper'

DEFAULT_CARRIER_ACCOUNT = 'bb980a0dcd2047328024bc3dcad56682'
DEFAULT_SERVICELEVEL_TOKEN = 'usps_priority'

# Retries up to 10 times to retrieve a valid
# Batch (which takes time to become 'VALID' from
# 'VALIDATING' after initially being created).
def retrieve_valid_batch(id)
  retries = 10
  retrieve = nil
  until retries == 0 do
    sleep 1
    retrieve = Shippo::Batch::get(id)
    break if retrieve[:object_status] == 'VALID'
    retries -= 1
  end
  STDERR.puts 'Unable to retrieve VALID Batch object' unless retrieve
  retrieve
end

RSpec.describe 'Shippo::API::Batch' do
  let(:dummy_batch) { DUMMY_BATCH }
  let(:dummy_shipment) { DUMMY_SHIPMENT }

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

  describe '#add_shipment' do
    it 'should properly add a shipment to an existing batch' do
      VCR.use_cassette('batch/test_add') do
        batch = Shippo::Batch::create(dummy_batch.dup)
        retrieve = retrieve_valid_batch(batch[:object_id])
        batch_size = retrieve.batch_shipments.results.length

        shipments = Array.new
        shipment = Shippo::Shipment::create(dummy_shipment.dup)
        shipments.push({"shipment" => shipment[:object_id]})

        added = Shippo::Batch::add_shipment(retrieve[:object_id], shipments)
        added_size = added.batch_shipments.results.length
        expect(batch_size + shipments.length).to be == added_size
      end
    end
  end
end