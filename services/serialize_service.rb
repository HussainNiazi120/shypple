# frozen_string_literal: true

# This service serializes a collection of sailings into a format that can be returned to the user.
class SerializeService < ApplicationService
  attr_reader :sailings

  def initialize(sailings)
    super()
    @sailings = sailings
  end

  def call
    sailings.map { |sailing| serialize_sailing(sailing) }
  end

  private

  def serialize_sailing(sailing)
    {
      origin_port: sailing.origin_port,
      destination_port: sailing.destination_port,
      departure_date: sailing.departure_date.strftime('%Y-%m-%d'),
      arrival_date: sailing.arrival_date.strftime('%Y-%m-%d'),
      sailing_code: sailing.sailing_code,
      rate: sailing.original_rate,
      rate_currency: sailing.rate_currency
    }
  end
end
