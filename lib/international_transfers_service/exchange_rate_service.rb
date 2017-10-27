require 'net/http'
require 'json'

class ExchangeRateService
  def initialize(base_url = 'http://exchange-rate-service:6000')
    @base_url = base_url
  end

  def get_exchange_rate(from, to, date)
    url = URI("#{@base_url}/exchangerate/#{from}/#{to}/#{date.year}/#{date.month}/#{date.day}")
    response = Net::HTTP.get_response url

    raise ExchangeRateServiceError, "HTTP call failed with status #{response.code}." if response.code != '200'

    parsed_response = JSON.parse response.body
    parsed_response['rate']
  end
end

class ExchangeRateServiceError < StandardError
end
