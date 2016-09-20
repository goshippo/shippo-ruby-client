require 'spec_helper'

RSpec.describe Shippo::API::Request do

  let(:json_string) { File.read('spec/fixtures/parcel_list.json') }
  let(:json) { JSON.parse(json_string, { symbolize_names: true }) }
  let(:method) { :get }
  let(:uri) { '/some-uri' }
  let(:params) { {} }
  let(:headers) { {'X-Authorize-Your-Mom' => 'Accepted' } }

  let(:api_request) { Shippo::API::Request.new(method: method, uri: uri, params: params, headers: headers) }
  let(:http_response) { RestClient::Response.create(json_string, 200, {}, { response: 'OK' }) }

  context '#new' do
    before do

      expect(RestClient::Request).to receive(:execute).and_return(http_response)
      api_request.execute
    end
    it 'should successfully return the response object' do
      expect(api_request.response).to_not be_nil
    end
    it 'should setup the response object' do
      expect(api_request.response).to eql(http_response)
    end
    it 'should parse the return the body' do
      expect(api_request.parsed_response).to eql(json.to_hash)
    end
  end

end
