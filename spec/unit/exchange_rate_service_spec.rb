require 'date'
require 'webmock/rspec'

RSpec.describe ExchangeRateService do
  base_url = 'http://exchangerateservice.megabank.com:1234'
  subject { ExchangeRateService.new base_url }

  describe '#get_exchange_rate' do
    context 'when the HTTP call succeeds' do
      before(:each) do
        stub_request(:get, "#{base_url}/exchangerate/AUD/EUR/2017/10/12")
          .to_return(status: 200, body: '{"rate": 1.23}')
      end

      it 'returns the exchange rate provided by the service' do
        exchange_rate = subject.get_exchange_rate('AUD', 'EUR', Date.new(2017, 10, 12))
        expect(exchange_rate).to eq(1.23)
      end
    end

    context 'when the HTTP call fails with a non-200 status code' do
      before(:each) do
        stub_request(:get, "#{base_url}/exchangerate/AUD/EUR/2017/10/12")
          .to_return(status: 404)
      end

      it 'throws an appropriate error' do
        expect { subject.get_exchange_rate('AUD', 'EUR', Date.new(2017, 10, 12)) }
          .to raise_error('HTTP call failed with status 404.')
      end
    end
  end
end
