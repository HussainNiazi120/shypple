# frozen_string_literal: true

module Search
  # This service finds all possible routes between two ports.
  class PossibleRoutesService < ApplicationService
    attr_reader :origin_port, :destination_port

    def initialize(origin_port, destination_port)
      super()
      @origin_port = origin_port
      @destination_port = destination_port
      @possible_routes = []
    end

    def call
      find_routes(origin_port, [], Time.now)
      possible_routes
    end

    private

    attr_reader :possible_routes

    def sailings
      @sailings ||= Sailing.all
    end

    def find_routes(current_port, current_route, last_arrival_time)
      if current_port == destination_port
        possible_routes << current_route.dup
        return
      end

      sailings.each do |sailing|
        next unless sailing.origin_port == current_port && sailing.departure_date >= last_arrival_time

        current_route << sailing
        find_routes(sailing.destination_port, current_route, sailing.arrival_date)
        current_route.pop
      end
    end
  end
end
