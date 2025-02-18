# frozen_string_literal: true

module WeatherGovApi
  # Wrapper for Weather.gov API responses
  # Provides convenient access to response status and parsed data
  class Response
    attr_reader :status, :data

    def initialize(response)
      @status = response.status
      @data = JSON.parse(response.body)
    end

    def success?
      status >= 200 && status < 300
    end
  end
end
