# frozen_string_literal: true

RSpec.describe SerializeService do
  describe '#call' do
    subject { described_class }

    context 'when there are no sailings' do
      let(:sailings) { [] }

      it 'returns an empty array' do
        expect(subject.call(sailings)).to eq([])
      end
    end

    context 'when there are sailings' do
      let(:sailing1) do
        instance_double(Sailing, origin_port: 'Port A', destination_port: 'Port B',
                                 departure_date: Date.today, arrival_date: Date.today + 1,
                                 sailing_code: 'SC001', original_rate: 100, rate_currency: 'USD')
      end
      let(:sailing2) do
        instance_double(Sailing, origin_port: 'Port C', destination_port: 'Port D',
                                 departure_date: Date.today + 2, arrival_date: Date.today + 3,
                                 sailing_code: 'SC002', original_rate: 200, rate_currency: 'EUR')
      end
      let(:sailings) { [sailing1, sailing2] }

      it 'returns serialized sailings' do
        expect(subject.call(sailings)).to eq([
                                               {
                                                 origin_port: 'Port A',
                                                 destination_port: 'Port B',
                                                 departure_date: Date.today.to_s,
                                                 arrival_date: (Date.today + 1).to_s,
                                                 sailing_code: 'SC001',
                                                 rate: 100,
                                                 rate_currency: 'USD'
                                               },
                                               {
                                                 origin_port: 'Port C',
                                                 destination_port: 'Port D',
                                                 departure_date: (Date.today + 2).to_s,
                                                 arrival_date: (Date.today + 3).to_s,
                                                 sailing_code: 'SC002',
                                                 rate: 200,
                                                 rate_currency: 'EUR'
                                               }
                                             ])
      end
    end
  end
end
