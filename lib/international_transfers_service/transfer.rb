class Transfer
  attr_reader :id, :from_currency, :to_currency, :transfer_date, :original_amount, :exchange_rate

  # rubocop:disable Metrics/ParameterLists
  def initialize(id, from_currency, to_currency, transfer_date, original_amount, exchange_rate)
    @id = id
    @from_currency = from_currency
    @to_currency = to_currency
    @transfer_date = transfer_date
    @original_amount = original_amount
    @exchange_rate = exchange_rate
  end

  # rubocop:disable Style/RedundantSelf
  def ==(other)
    self.id == other.id &&
      self.from_currency == other.from_currency &&
      self.to_currency == other.to_currency &&
      self.transfer_date == other.transfer_date &&
      self.exchange_rate == other.exchange_rate
  end
  # rubocop:enable Style/RedundantSelf

  def to_json(*)
    {
      id: @id,
      fromCurrency: @from_currency,
      toCurrency: @to_currency,
      transferDate: @transfer_date,
      originalAmount: @original_amount,
      exchangeRate: @exchange_rate
    }.to_json
  end
end
