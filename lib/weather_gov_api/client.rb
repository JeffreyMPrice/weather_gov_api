# frozen_string_literal: true
require_relative "middleware/error_handler"

module WeatherGovApi
  # Client for interacting with the Weather.gov API
  # Handles requests to fetch weather data for US coordinates
  class Client
    BASE_URL = "https://api.weather.gov"

    def initialize(user_agent: nil)
      @user_agent = user_agent || "WeatherGovApi Ruby Gem (#{WeatherGovApi::VERSION})"
    end

    def points(latitude:, longitude:)
      response = connection.get("/points/#{latitude},#{longitude}")
      Response.new(response)
    end
  
    # rubocop:disable Metrics/MethodLength
    def observation_stations(latitude:, longitude:)
      points_response = points(latitude: latitude, longitude: longitude)
      stations_url = points_response.data.dig("properties", "observationStations")
      unless stations_url
        raise WeatherGovApi::ClientError, "No observation stations URL found in points response"
      end

      stations_path = observation_stations_path(stations_url)

      response = connection.get(stations_path)
      raise_api_error(response) unless response.success?
      Response.new(response)
    end
    # rubocop:enable Metrics/MethodLength

    # Retrieves the latest observation for the nearest weather station to the given coordinates.
    #
    # @param latitude [Float] The latitude of the location.
    # @param longitude [Float] The longitude of the location.
    # @return [Response] The API response containing the latest observation.
    # @raise [WeatherGovApi::ClientError] if no observation stations are found.
    # @raise [WeatherGovApi::ServerError] for 5xx API errors.
    # @raise [WeatherGovApi::NetworkError] for network failures.
    def current_weather(latitude:, longitude:)
      stations_response = observation_stations(latitude: latitude, longitude: longitude)
      station = stations_response.data.dig("features", 0)
      raise WeatherGovApi::ApiError.new(message: "No observation stations found") unless station

      station_id = station.dig("properties", "stationIdentifier")
      response = connection.get("/stations/#{station_id}/observations/latest")
      Response.new(response)
    end

    def forecast(latitude:, longitude:)
      grid_data = points(latitude: latitude, longitude: longitude).data["properties"]
      grid_id = grid_data["gridId"]
      grid_x = grid_data["gridX"]
      grid_y = grid_data["gridY"]

      response = connection.get("/gridpoints/#{grid_id}/#{grid_x},#{grid_y}/forecast")
      raise_api_error(response) unless response.success?
      Response.new(response)
    rescue Faraday::Error => e
      raise WeatherGovApi::ApiError.new(message: "API request failed: #{e.message}")
    end

    private

    def observation_stations_path(url)
      uri = URI.parse(url)
      unless uri.host == URI.parse(BASE_URL).host
        raise WeatherGovApi::ApiError.new(message: "Invalid observation stations URL: #{url}")
      end

      uri.path
    end

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers["User-Agent"] = @user_agent
        faraday.headers["Accept"] = "application/json"
        faraday.use WeatherGovApi::Middleware::ErrorHandler
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
