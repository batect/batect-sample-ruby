# frozen_string_literal: true

require 'net/http'

RSpec.describe 'the international transfers service' do
  let(:base_url) { 'http://international-transfers-service:4567' }

  context 'after creating a transfer' do
    let(:transfers_url) { URI("#{base_url}/transfers") }
    let(:transfer_creation_headers) { { 'Content-Type' => 'application/json;charset=utf-8' } }
    let(:transfer_creation_json) do
      <<-JSON
        {
          "fromCurrency": "AUD",
          "toCurrency": "EUR",
          "transferDate": "2017-02-13",
          "originalAmount": 100.50
        }
      JSON
    end

    before(:each) do
      creation_response = Net::HTTP.post(transfers_url, transfer_creation_json, transfer_creation_headers)
      expect(creation_response.code).to eq('201')
    end

    context 'when then getting all transfers' do
      let(:response) { Net::HTTP.get_response transfers_url }

      it 'returns the details of the newly created transfer in the list of all transfers' do
        expect(response.code).to eq('200')

        expected_body = {
          transfers: [
            {
              fromCurrency: 'AUD',
              toCurrency: 'EUR',
              transferDate: '2017-02-13',
              originalAmount: 100.50,
              exchangeRate: 0.50
            }
          ]
        }

        expect(response.body).to be_json_eql(expected_body.to_json)
      end
    end
  end
end
