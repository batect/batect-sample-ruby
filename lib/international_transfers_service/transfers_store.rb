# frozen_string_literal: true

require 'pg'

class TransfersStore
  def initialize
    # In a production setting, you would not hardcode these credentials.
    options = {
      host: 'database',
      dbname: 'international-transfers-service',
      user: 'international-transfers-service',
      password: 'TheSuperSecretPassword'
    }

    @connection = PG.connect options
  end

  def load_all_transfers
    sql = 'SELECT id, from_currency, to_currency, transfer_date, original_amount, exchange_rate FROM transfers;'
    transfers = []

    @connection.exec(sql).each do |row|
      transfers << transfer_from_row(row)
    end

    transfers
  end

  def save_transfer(transfer)
    sql = 'INSERT INTO transfers (id, from_currency, to_currency, transfer_date, original_amount, exchange_rate)
           VALUES ($1, $2, $3, $4, $5, $6);'

    params = [
      transfer.id,
      transfer.from_currency,
      transfer.to_currency,
      transfer.transfer_date,
      transfer.original_amount,
      transfer.exchange_rate
    ]

    @connection.exec_params(sql, params)
  end

  private

  def transfer_from_row(row)
    id = row['id']
    from_currency = row['from_currency']
    to_currency = row['to_currency']
    transfer_date = Date.parse(row['transfer_date'])
    original_amount = row['original_amount'].to_f
    exchange_rate = row['exchange_rate'].to_f
    Transfer.new(id, from_currency, to_currency, transfer_date, original_amount, exchange_rate)
  end
end
