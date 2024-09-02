# frozen_string_literal: true

RSpec.describe Search::CheapestDirectService, type: :service do
  let(:service) { described_class }

  describe '#call' do
    after(:each) do
      Sailing.all.clear
    end

    context 'when there are no sailings' do
      it 'returns an empty array when there is no sailing data' do
        expect(service.call('A', 'B')).to eq([])
      end

      it 'returns an empty array when there is no direct route' do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'B',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC001' },
          {
            rate: 100,
            original_rate: 100,
            rate_currency: 'eur'
          }
        )

        Sailing.new(
          { origin_port: 'B',
            destination_port: 'C',
            departure_date: (Date.today + 2).to_s,
            arrival_date: (Date.today + 3).to_s,
            sailing_code: 'SC002' },
          {
            rate: 100,
            original_rate: 100,
            rate_currency: 'eur'
          }
        )

        expect(service.call('A', 'C')).to eq([])
      end
    end

    context 'when routes are found' do
      let!(:sailing1) do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'B',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC001' },
          {
            rate: 100,
            original_rate: 100,
            rate_currency: 'eur'
          }
        )
      end

      let!(:sailing2) do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'B',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC002' },
          {
            rate: 50,
            original_rate: 100,
            rate_currency: 'eur'
          }
        )
      end

      let!(:sailing3) do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'B',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC003' },
          {
            rate: 50,
            original_rate: 100,
            rate_currency: 'eur'
          }
        )
      end

      it 'returns the first cheapest direct route' do
        result = service.call('A', 'B')

        expect(result).to contain_exactly(sailing2)
      end
    end
  end
end
