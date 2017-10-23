require 'rack/test'
require 'rspec/json_expectations'

RSpec.describe InternationalTransfersServiceApp do
  include Rack::Test::Methods

  let(:store) { instance_double('TransfersStore') }
  let(:app) { InternationalTransfersServiceApp.new(store) }

  describe '/transfers' do
    describe 'GET' do
      sample_transfer = Transfer.new('abc123', 'AUD', 'HUF', Date.new(2017, 10, 23), 100.50, 1.23)

      before(:each) do
        allow(store).to receive(:load_all_transfers).and_return([sample_transfer])

        get '/transfers'
      end

      it 'returns a HTTP 200 response' do
        expect(last_response.status).to eq(200)
      end

      it 'returns an appropriate Content-Type header' do
        expect(last_response.content_type).to eq('application/json;charset=utf-8')
      end

      it 'returns the list of all transfers in JSON format' do
        expected_body = {
          transfers: [
            {
              id: 'abc123',
              fromCurrency: 'AUD',
              toCurrency: 'HUF',
              transferDate: '2017-10-23',
              originalAmount: 100.50,
              exchangeRate: 1.23
            }
          ]
        }

        expect(last_response.body).to include_json(expected_body)
      end
    end
  end
end
