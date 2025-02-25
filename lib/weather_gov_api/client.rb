# frozen_string_literal: true

module WeatherGovApi
  # Client for interacting with the Weather.gov API
  # Handles requests to fetch weather data for US coordinates
  class Client
    BASE_URL = "https://api.weather.gov"

    def initialize(user_agent: nil)
      @user_agent = user_agent || "WeatherGovApi Ruby Gem (#{WeatherGovApi::VERSION})"
    end

    def points(latitude:, longitude:)
      validate_coordinates(latitude, longitude)
      response = connection.get("/points/#{latitude},#{longitude}")
      Response.new(response)
    rescue Faraday::Error => e
      raise Error, "API request failed: #{e.message}"
    end

    def observation_stations(latitude:, longitude:)
      points_response = points(latitude: latitude, longitude: longitude)
      stations_url = points_response.data.dig("properties", "observationStations")
      raise Error, "No observation stations URL found in points response" unless stations_url

      response = connection.get(stations_url.sub(BASE_URL, ""))
      Response.new(response)
    rescue Faraday::Error => e
      raise Error, "API request failed: #{e.message}"
    end

    def current_weather(latitude:, longitude:)
      stations_response = observation_stations(latitude: latitude, longitude: longitude)
      station = stations_response.data.dig("features", 0)
      raise Error, "No observation stations found" unless station

      station_id = station.dig("properties", "stationIdentifier")
      response = connection.get("/stations/#{station_id}/observations/latest")
      Response.new(response)
    rescue Faraday::Error => e
      raise Error, "API request failed: #{e.message}"
    end

    private

    def validate_coordinates(latitude, longitude)
      raise ArgumentError, "Invalid latitude: must be between -90 and 90" unless latitude.between?(-90, 90)

      return if longitude.between?(-180, 180)

      raise ArgumentError, "Invalid longitude: must be between -180 and 180"
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers["User-Agent"] = @user_agent
        faraday.headers["Accept"] = "application/json"
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
