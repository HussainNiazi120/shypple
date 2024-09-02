# frozen_string_literal: true

module ShippingData
  # This service populates the database with sailing data.
  class PopulateService < ApplicationService
    class MissingSailingData < StandardError; end
    class MissingRateData < StandardError; end
    class MissingRateDataForSailingCode < StandardError; end
    class MissingExchangeRateData < StandardError; end

    def initialize(data)
      super()
      parsed_data = JSON.parse(data, symbolize_names: true)
      @sailings = parsed_data[:sailings]
      @rates = parsed_data[:rates]
      @exchange_rates = parsed_data[:exchange_rates]

      raise(MissingSailingData, 'No sailing data found') if @sailings.nil? || @sailings.empty?
      raise(MissingRateData, 'No rate data found') if @rates.nil? || @rates.empty?
    end

    def call
      @sailings.each do |sailing_data|
        sailing_code = sailing_data[:sailing_code]
        rate_data = find_rate_data(sailing_code)
        rate = build_rate(rate_data, sailing_data[:departure_date], sailing_code)
        Sailing.new(sailing_data, rate)
      end
    end

    private

    def find_rate_data(sailing_code)
      @rates.find do |rate|
        rate[:sailing_code] == sailing_code
      end || raise(MissingRateDataForSailingCode,
                   "No rate data found for sailing code: #{sailing_code}")
    end

    def build_rate(rate_data, departure_date, sailing_code)
      {
        rate: calculate_rate(rate_data, departure_date, sailing_code),
        original_rate: rate_data[:rate],
        rate_currency: rate_data[:rate_currency]
      }
    end

    def calculate_rate(rate_data, departure_date, sailing_code)
      rate = to_big_decimal(rate_data[:rate])
      return rate if rate_data[:rate_currency] == DEFAULT_CURRENCY

      exchange_rate = find_exchange_rate(rate_data[:rate_currency], departure_date, sailing_code)
      rate / to_big_decimal(exchange_rate)
    end

    def find_exchange_rate(currency, date, sailing_code)
      raise_exchange_rate_error(currency, date, sailing_code) if @exchange_rates.nil?

      exchange_rate_date = @exchange_rates.fetch(date.to_sym) do
        raise_exchange_rate_error(currency, date, sailing_code)
      end

      exchange_rate_date.fetch(currency.downcase.to_sym) do
        raise_exchange_rate_error(currency, date, sailing_code)
      end
    end

    def raise_exchange_rate_error(currency, date, sailing_code)
      raise(MissingExchangeRateData,
            "No exchange rate found for currency: #{currency} for departure date: #{date},\
             sailing code: #{sailing_code}")
    end

    def to_big_decimal(value)
      BigDecimal(value.to_s)
    end
  end
end
