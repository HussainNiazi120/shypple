# frozen_string_literal: true

module Search
  # This service finds the cheapest sailing between two ports.
  class CheapestService < ApplicationService
    attr_reader :origin_port, :destination_port

    def initialize(origin_port, destination_port)
      super()
      @origin_port = origin_port
      @destination_port = destination_port
    end

    def call
      cheapest_route || []
    end

    private

    def possible_routes
      @possible_routes ||= PossibleRoutesService.call(origin_port, destination_port)
    end

    def cheapest_route
      possible_routes.min_by { |route| route.sum(&:rate) }
    end
  end
end
