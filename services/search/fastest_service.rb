# frozen_string_literal: true

module Search
  # This service finds the fastest sailing between two ports.
  class FastestService < ApplicationService
    attr_reader :origin_port, :destination_port

    def initialize(origin_port, destination_port)
      super()
      @origin_port = origin_port
      @destination_port = destination_port
    end

    def call
      fastest_route || []
    end

    private

    def possible_routes
      @possible_routes ||= PossibleRoutesService.call(origin_port, destination_port)
    end

    def fastest_route
      possible_routes.min_by { |route| route.last.arrival_date - route.first.departure_date }
    end
  end
end
