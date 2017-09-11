require 'spec_helper'

RSpec.describe Shippo::API::Request do

  let(:json_string) { File.read('spec/fixtures/parcel_list.json') }
  let(:json) { JSON.parse(json_string, { symbolize_names: true }) }
  let(:method) { :get }
  let(:uri) { '/some-uri' }
  let(:params) { {} }
  let(:headers) { {'X-Authorize' => 'Accepted'} }
  let(:open_timeout) { 1 }
  let(:read_timeout) { 2 }

  let(:api_request) { Shippo::API::Request.new(method: method, uri: uri, params: params, headers: headers) }
  let(:net_http) { instance_double('Net::HTTPResponse', {to_hash: {'Status' => ['200 OK']}, code: '200', body: 'foo'}) }
  let(:http_response) { RestClient::Response.create(json_string, net_http, api_request) }

  context '#new' do
    before do |example|
      unless example.metadata[:skip_before]
        Shippo::API.open_timeout = open_timeout
        Shippo::API.read_timeout = read_timeout
        Shippo::API.version = "2017-03-29"
      end
        allow(RestClient::Request).to receive(:execute).and_return(http_response)
        api_request.execute
    end
    it 'should include Shippo-API-Version in header if one is specified' do
      expect(api_request.headers[:'Shippo-API-Version']).to eql("2017-03-29")
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
    it 'should use configured open timeout' do
      expect(RestClient::Request).to have_received(:execute).with(hash_including(open_timeout: open_timeout))
    end
    it 'should use configured read timeout' do
      expect(RestClient::Request).to have_received(:execute).with(hash_including(timeout: read_timeout))
    end
  end

end
