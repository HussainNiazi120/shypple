# frozen_string_literal: true

RSpec.describe Search::PossibleRoutesService, type: :service do
  let(:service) { described_class }
  let(:rate_data) { { rate: 100, original_rate: 100, rate_currency: 'eur' } }

  describe '#call' do
    after(:each) do
      Sailing.all.clear
    end

    context 'when no routes are found' do
      it 'returns an empty array when there is no sailing data' do
        expect(service.call('A', 'B')).to eq([])
      end

      it 'returns an empty array when there are no possible routes' do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'C',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC001' }, rate_data
        )

        Sailing.new(
          { origin_port: 'B',
            destination_port: 'C',
            departure_date: (Date.today + 2).to_s,
            arrival_date: (Date.today + 3).to_s,
            sailing_code: 'SC002' }, rate_data
        )

        expect(service.call('A', 'B')).to eq([])
      end

      it 'returns an empty array when the dates do not match' do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'C',
            departure_date: (Date.today - 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC001' }, rate_data
        )

        Sailing.new(
          { origin_port: 'A',
            destination_port: 'B',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC002' }, rate_data
        )

        Sailing.new(
          { origin_port: 'B',
            destination_port: 'C',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 3).to_s,
            sailing_code: 'SC003' }, rate_data
        )

        expect(service.call('A', 'C')).to eq([])
      end
    end

    context 'when routes are found' do
      let!(:sailing1) do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'C',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC001' }, rate_data
        )
      end

      let!(:sailing2) do
        Sailing.new(
          { origin_port: 'A',
            destination_port: 'B',
            departure_date: (Date.today + 1).to_s,
            arrival_date: (Date.today + 2).to_s,
            sailing_code: 'SC002' }, rate_data
        )
      end

      let!(:sailing3) do
        Sailing.new(
          { origin_port: 'B',
            destination_port: 'C',
            departure_date: (Date.today + 2).to_s,
            arrival_date: (Date.today + 3).to_s,
            sailing_code: 'SC003' }, rate_data
        )
      end

      it 'returns the correct routes' do
        result = service.call('A', 'C')
        expect(result).to contain_exactly([sailing1], [sailing2, sailing3])
      end
    end
  end
end
