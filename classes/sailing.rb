# frozen_string_literal: true

# This is the Sailing class. It represents a sailing between two ports.
class Sailing
  attr_reader :origin_port, :destination_port, :departure_date, :arrival_date, :sailing_code, :rate, :original_rate,
              :rate_currency

  @all_sailings = []

  def initialize(sailing_data, rate)
    @origin_port = sailing_data[:origin_port]
    @destination_port = sailing_data[:destination_port]
    @departure_date = parse_date(sailing_data[:departure_date])
    @arrival_date = parse_date(sailing_data[:arrival_date])
    @sailing_code = sailing_data[:sailing_code]
    @rate = rate[:rate]
    @original_rate = rate[:original_rate]
    @rate_currency = rate[:rate_currency]

    validate_presence

    self.class.all_sailings << self
  end

  def self.all
    all_sailings
  end

  class << self
    attr_reader :all_sailings
  end

  private

  def parse_date(date_str)
    date_str ? Time.strptime(date_str, '%Y-%m-%d') : nil
  end

  def validate_presence
    missing_attributes = instance_variables.select do |var|
      value = instance_variable_get(var)
      value.nil? || (value.respond_to?(:empty?) && value.empty?)
    end

    return if missing_attributes.empty?

    raise ArgumentError, "Missing attributes: #{missing_attributes.map { |attr| attr.to_s.delete('@') }.join(', ')}"
  end
end
