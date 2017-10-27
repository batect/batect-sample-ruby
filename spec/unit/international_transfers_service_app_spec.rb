require 'rack/test'
require 'rspec/json_expectations'

RSpec.describe InternationalTransfersServiceApp do
  include Rack::Test::Methods

  let(:transfers_store) { instance_double('TransfersStore') }
  let(:exchange_rate_service) { instance_double('ExchangeRateService') }
  let(:app) { InternationalTransfersServiceApp.new(transfers_store, exchange_rate_service) }

  describe '/transfers' do
    describe 'GET' do
      sample_transfer = Transfer.new('abc123', 'AUD', 'HUF', Date.new(2017, 10, 23), 100.50, 1.23)

      before(:each) do
        allow(transfers_store).to receive(:load_all_transfers).and_return([sample_transfer])

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

    describe 'POST' do
      json = <<-JSON
      {
        "fromCurrency": "AUD",
        "toCurrency": "HUF",
        "transferDate": "2017-10-23",
        "originalAmount": 100.50
      }
      JSON

      transfer_saved = nil

      before(:each) do
        transfer_saved = nil

        allow(exchange_rate_service).to receive(:get_exchange_rate)
          .with('AUD', 'HUF', Date.new(2017, 10, 23))
          .and_return(1.23)

        # FIXME: This is a bit gross - ideally we'd do an expect(...).to receive(...),
        # but we can't do that because we don't know what the transfer will look like
        # until we get the response back (because we don't control the ID generation,
        # and don't want to).
        allow(transfers_store).to receive(:save_transfer) { |transfer|
          transfer_saved = transfer
        }

        post('/transfers', json, 'CONTENT_TYPE' => 'application/json')
      end

      it 'returns a HTTP 200 response' do
        expect(last_response.status).to eq(200)
      end

      it 'returns an appropriate Content-Type header' do
        expect(last_response.content_type).to eq('application/json;charset=utf-8')
      end

      it 'returns the details of the newly created transfer in the response body' do
        expected_body = {
          fromCurrency: 'AUD',
          toCurrency: 'HUF',
          transferDate: '2017-10-23',
          originalAmount: 100.50
        }

        expect(last_response.body).to include_json(expected_body)
      end

      it 'returns the ID of the newly created transfer in the response body' do
        uuid_matcher = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

        expect(last_response.body).to include_json(
          id: uuid_matcher
        )
      end

      it 'returns the exchange rate used for the transfer in the response body' do
        expect(last_response.body).to include_json(
          exchangeRate: 1.23
        )
      end

      it 'saves the transfer to the database' do
        response_json = JSON.parse(last_response.body)
        expected_transfer = Transfer.new(response_json['id'], 'AUD', 'HUF', Date.new(2017, 10, 23), 100.50, 1.23)

        expect(transfer_saved).to eq(expected_transfer)
      end
    end
  end
end
