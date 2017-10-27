require 'sinatra/base'
require 'securerandom'

class InternationalTransfersServiceApp < Sinatra::Base
  def initialize(transfers_store = TransfersStore.new, exchange_rate_service = ExchangeRateService.new)
    super()
    @transfers_store = transfers_store
    @exchange_rate_service = exchange_rate_service
  end

  get '/transfers' do
    body = {
      transfers: @transfers_store.load_all_transfers
    }

    return_json body
  end

  post '/transfers' do
    body = JSON.parse(request.body.read)

    id = SecureRandom.uuid
    from_currency = body['fromCurrency']
    to_currency = body['toCurrency']
    date = Date.parse(body['transferDate'])
    exchange_rate = @exchange_rate_service.get_exchange_rate(from_currency, to_currency, date)

    transfer = Transfer.new(id, from_currency, to_currency, date, body['originalAmount'], exchange_rate)
    @transfers_store.save_transfer transfer

    return_json transfer
  end

  private

  def return_json(body)
    headers = {
      'Content-Type' => 'application/json;charset=utf-8'
    }

    [200, headers, JSON.dump(body)]
  end
end
