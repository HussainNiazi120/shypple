# frozen_string_literal: true

module Search
  # This service finds the cheapest direct sailing between two ports.
  class CheapestDirectService < ApplicationService
    attr_reader :origin_port, :destination_port

    def initialize(origin_port, destination_port)
      super()
      @origin_port = origin_port
      @destination_port = destination_port
    end

    def call
      cheapest_sailing ? [cheapest_sailing] : []
    end

    private

    def eligible_sailings
      @eligible_sailings ||= Sailing.all.select { |sailing| direct_and_upcoming?(sailing) }
    end

    def direct_and_upcoming?(sailing)
      sailing.origin_port == origin_port &&
        sailing.destination_port == destination_port &&
        sailing.departure_date >= Time.now
    end

    def cheapest_sailing
      @cheapest_sailing ||= eligible_sailings.min_by(&:rate)
    end
  end
end
