require 'sinatra/base'

class InternationalTransfersServiceApp < Sinatra::Base
  def initialize(transfers_store = TransfersStore.new)
    super()
    @transfers_store = transfers_store
  end

  get '/transfers' do
    body = {
      transfers: @transfers_store.load_all_transfers
    }

    return_json body
  end

  private

  def return_json(body)
    headers = {
      'Content-Type' => 'application/json;charset=utf-8'
    }

    [200, headers, JSON.dump(body)]
  end
end
