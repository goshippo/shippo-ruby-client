require 'rubygems'
require 'spec_helper'

RSpec.describe 'Shippo::API::Parcel' do
  let(:json) { JSON::parse(File.read('spec/fixtures/parcel_list.json')) }

  describe 'parcel import' do
    # get an array of test parcels from JSON
    let(:result) { Shippo::Parcel.from(json) }
    it 'should read data from the json' do
      # test the various options of accessi bg the parcel data
      expect(result[:metadata]).to eql('Customer ID 123456')
      expect(result.object.owner).to eql('tobias.schottdorf@gmail.com')
    end

    context 'should be able to assign and read data' do
      describe 'via string accessors' do
        before do
          result['metadata'] = 'Customer ID 007'
        end
        it 'should equal to the assigned value' do
          expect(result.metadata).to eql('Customer ID 007')
        end
      end

      describe 'via symbol accessors' do
        before do
          result[:object_owner] = 'hans.wurst@gmail.com'
        end
        it 'should equal to the assigned value' do
          expect(result['object_owner']).to eql('hans.wurst@gmail.com')
        end
      end
    end
  end
end
