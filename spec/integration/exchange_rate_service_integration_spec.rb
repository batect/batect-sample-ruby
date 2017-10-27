require 'date'

RSpec.describe ExchangeRateService do
  describe '#get_exchange_rate' do
    it 'returns the requested exchange rate' do
      date = Date.new(2017, 2, 13)
      exchange_rate = subject.get_exchange_rate('AUD', 'EUR', date)

      expect(exchange_rate).to eq 0.50
    end
  end
end
