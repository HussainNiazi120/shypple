# frozen_string_literal: true

RSpec.describe Sailing do
  let(:valid_sailing_data) do
    {
      origin_port: 'Port A',
      destination_port: 'Port B',
      departure_date: '2023-10-01',
      arrival_date: '2023-10-05',
      sailing_code: 'SC123'
    }
  end

  let(:valid_rate) do
    {
      rate: 1000,
      original_rate: 1200,
      rate_currency: 'USD'
    }
  end

  context 'when all attributes are present' do
    it 'creates a new Sailing instance' do
      sailing = Sailing.new(valid_sailing_data, valid_rate)
      expect(sailing).to be_an_instance_of(Sailing)
    end
  end

  context 'when any attribute is missing' do
    it 'raises an error for missing origin_port' do
      invalid_data = valid_sailing_data.dup
      invalid_data.delete(:origin_port)
      expect { Sailing.new(invalid_data, valid_rate) }.to raise_error(ArgumentError, /Missing attributes: origin_port/)
    end

    it 'raises an error for missing destination_port' do
      invalid_data = valid_sailing_data.dup
      invalid_data.delete(:destination_port)
      expect do
        Sailing.new(invalid_data, valid_rate)
      end.to raise_error(ArgumentError, /Missing attributes: destination_port/)
    end

    it 'raises an error for missing departure_date' do
      invalid_data = valid_sailing_data.dup
      invalid_data.delete(:departure_date)
      expect do
        Sailing.new(invalid_data, valid_rate)
      end.to raise_error(ArgumentError, /Missing attributes: departure_date/)
    end

    it 'raises an error for missing arrival_date' do
      invalid_data = valid_sailing_data.dup
      invalid_data.delete(:arrival_date)
      expect { Sailing.new(invalid_data, valid_rate) }.to raise_error(ArgumentError, /Missing attributes: arrival_date/)
    end

    it 'raises an error for missing sailing_code' do
      invalid_data = valid_sailing_data.dup
      invalid_data.delete(:sailing_code)
      expect { Sailing.new(invalid_data, valid_rate) }.to raise_error(ArgumentError, /Missing attributes: sailing_code/)
    end

    it 'raises an error for missing rate' do
      invalid_rate = valid_rate.dup
      invalid_rate.delete(:rate)
      expect { Sailing.new(valid_sailing_data, invalid_rate) }.to raise_error(ArgumentError, /Missing attributes: rate/)
    end

    it 'raises an error for missing original_rate' do
      invalid_rate = valid_rate.dup
      invalid_rate.delete(:original_rate)
      expect do
        Sailing.new(valid_sailing_data, invalid_rate)
      end.to raise_error(ArgumentError, /Missing attributes: original_rate/)
    end

    it 'raises an error for missing rate_currency' do
      invalid_rate = valid_rate.dup
      invalid_rate.delete(:rate_currency)
      expect do
        Sailing.new(valid_sailing_data, invalid_rate)
      end.to raise_error(ArgumentError, /Missing attributes: rate_currency/)
    end
  end
end
