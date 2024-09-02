# frozen_string_literal: true

module ShippingData
  # This service retrieves data from the shipping data API.
  class GetService < ApplicationService
    API_URL = 'https://mapreduce.shypple.com/api/'

    def call
      url = URI(API_URL)
      response = Net::HTTP.get_response(url)

      raise 'Failed to retrieve data from API.' unless response.is_a?(Net::HTTPSuccess)

      response.body
    end
  end
end
