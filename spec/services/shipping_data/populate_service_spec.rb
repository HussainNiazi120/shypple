# frozen_string_literal: true

# spec/services/populate_service_spec.rb
RSpec.describe ShippingData::PopulateService, type: :service do
  let(:valid_data) do
    {
      sailings: [
        { origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2022-02-01', arrival_date: '2022-03-01',
          sailing_code: 'SC001' }
      ],
      rates: [
        { sailing_code: 'SC001', rate: 100, rate_currency: 'USD' }
      ],
      exchange_rates: {
        '2022-02-01': { usd: 2.0 }
      }
    }
  end

  let(:data_without_sailing_data) do
    { rates: [{ sailing_code: 'SC001', rate: 100, rate_currency: 'USD' }],
      exchange_rates: { '2022-02-01': { usd: 1.0 } } }
  end
  let(:missing_sailing_data_attribute) do
    {
      sailings: [{ destination_port: 'NLRTM', departure_date: '2022-02-01', arrival_date: '2022-03-01',
                   sailing_code: 'SC001' }], rates: [{ sailing_code: 'SC001', rate: 100, rate_currency: 'USD' }],
      exchange_rates: { '2022-02-01': { usd: 1.0 } }
    }
  end
  let(:data_without_rates_data) do
    {
      sailings: [{ origin_port: 'CNSHA', destination_port: 'NLRTM', departure_date: '2022-02-01',
                   arrival_date: '2022-03-01', sailing_code: 'SC001' }],
      exchange_rates: { '2022-02-01': { usd: 1.0 } }
    }
  end
  let(:missing_rate_data_for_sailing) do
    {
      sailings: [{ destination_port: 'NLRTM', departure_date: '2022-02-01', arrival_date: '2022-03-01',
                   sailing_code: 'SC001' }],
      rates: [{ sailing_code: 'SC002', rate: 100, rate_currency: 'USD' }]
    }
  end
  let(:missing_exchange_rate_data) do
    {
      sailings: [{ destination_port: 'NLRTM', departure_date: '2022-02-01', arrival_date: '2022-03-01',
                   sailing_code: 'SC001' }],
      rates: [{ sailing_code: 'SC001', rate: 100, rate_currency: 'USD' }]
    }
  end
  let(:missing_exchange_rate_data_for_currency) do
    {
      sailings: [{ destination_port: 'NLRTM', departure_date: '2022-02-01', arrival_date: '2022-03-01',
                   sailing_code: 'SC001' }],
      rates: [{ sailing_code: 'SC001', rate: 100, rate_currency: 'USD' }],
      exchange_rates: { '2022-02-01': { jpy: 1.0 } }
    }
  end
  let(:missing_exchange_rate_for_departure_date) do
    {
      sailings: [{ destination_port: 'NLRTM', departure_date: '2022-02-01', arrival_date: '2022-03-01',
                   sailing_code: 'SC001' }],
      rates: [{ sailing_code: 'SC001', rate: 100, rate_currency: 'USD' }],
      exchange_rates: { '2022-02-02': { usd: 1.0 } }
    }
  end

  describe '#call' do
    let(:service) { ShippingData::PopulateService }

    context 'with valid data' do
      it 'populates sailing data successfully' do
        expect { service.call(valid_data.to_json) }.not_to raise_error
        expect(Sailing.all).not_to be_empty
      end

      it 'converts and stores the currency into sailing object' do
        service.call(valid_data.to_json)
        sailing = Sailing.all.first
        expect(sailing.rate_currency).to eq('USD')
        expect(sailing.rate).to eq(50)
        expect(sailing.original_rate).to eq(100)
      end
    end

    context 'with missing sailing data' do
      it 'raises MissingSailingData error' do
        expect do
          service.call(data_without_sailing_data.to_json)
        end.to raise_error(ShippingData::PopulateService::MissingSailingData)
      end

      it 'raises MissingSailingData error when sailings data is empty' do
        data_with_empty_sailing_data = { sailings: [], rates: [], exchange_rates: {} }
        expect do
          service.call(data_with_empty_sailing_data.to_json)
        end.to raise_error(ShippingData::PopulateService::MissingSailingData)
      end

      it 'raises MissingSailingData error when one of the sailing_data attributes is missing' do
        expect do
          service.call(missing_sailing_data_attribute.to_json)
        end.to raise_error(ArgumentError, /Missing attributes: origin_port/)
      end
    end

    context 'with missing rate data' do
      it 'raises MissingRateData error when rates do not exist' do
        expect do
          service.call(data_without_rates_data.to_json)
        end.to raise_error(ShippingData::PopulateService::MissingRateData,
                           'No rate data found')
      end

      it 'raises MissingRateDataForSailingCode error when rate data does not exist for sailing code' do
        expect do
          service.call(missing_rate_data_for_sailing.to_json)
        end.to raise_error(
          ShippingData::PopulateService::MissingRateDataForSailingCode, 'No rate data found for sailing code: SC001'
        )
      end
    end

    context 'with missing exchange rate data' do
      it 'raises MissingExchangeRateData error when exchange rate for sailing currency is missing' do
        expect do
          service.call(missing_exchange_rate_data.to_json)
        end.to raise_error(ShippingData::PopulateService::MissingExchangeRateData)
      end

      it 'raises MissingExchangeRateData error when exchange rate for departure date is missing' do
        expect do
          service.call(missing_exchange_rate_for_departure_date.to_json)
        end.to raise_error(ShippingData::PopulateService::MissingExchangeRateData)
      end

      it 'raises MissingExchangeRateData error when exchange rate data is entirely missing' do
        expect do
          service.call(missing_exchange_rate_data.to_json)
        end.to raise_error(ShippingData::PopulateService::MissingExchangeRateData)
      end
    end
  end
end
