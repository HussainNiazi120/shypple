# frozen_string_literal: true

RSpec.describe ShippingData::GetService do
  let(:api_url) { 'https://mapreduce.shypple.com/api/' }
  let(:service) { described_class }

  before do
    stub_request(:get, api_url)
  end

  describe '#call' do
    context 'when the API request is successful' do
      let(:response_body) do
        '{
          "sailings": [
            {
              "origin_port": "CNSHA",
              "destination_port": "NLRTM",
              "departure_date": "2022-02-01",
              "arrival_date": "2022-03-01",
              "sailing_code": "ABCD"
            }
          ],
          "rates": [
            {
              "sailing_code": "ABCD",
              "rate": "589.30",
              "rate_currency": "USD"
            }
          ],
          "exchange_rates": {
            "2022-02-01": {
              "usd": 1.1138,
              "jpy": 130.85
            }
          }
        }'
      end

      before do
        stub_request(:get, api_url)
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
      end

      it 'returns the response body' do
        expect(service.call).to eq(response_body)
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:get, api_url)
          .to_return(status: 500, body: 'Internal Server Error')
      end

      it 'raises error' do
        expect { service.call }.to raise_error('Failed to retrieve data from API.')
      end
    end
  end
end
