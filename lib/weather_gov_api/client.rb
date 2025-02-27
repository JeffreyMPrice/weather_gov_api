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
      raise_api_error(response) unless response.success?
      Response.new(response)
    rescue Faraday::Error => e
      raise ApiError.new(message: "API request failed: #{e.message}")
    end


    def observation_stations(latitude:, longitude:)
      points_response = points(latitude: latitude, longitude: longitude)
      stations_url = points_response.data.dig("properties", "observationStations")
      raise ApiError.new(message: "No observation stations URL found in points response") unless stations_url


      stations_path = observation_stations_path(stations_url)

      response = connection.get(stations_path)
      raise_api_error(response) unless response.success?
      Response.new(response)
    rescue Faraday::Error => e
      raise ApiError.new(message: "API request failed: #{e.message}")
    end

    def current_weather(latitude:, longitude:)
      stations_response = observation_stations(latitude: latitude, longitude: longitude)
      station = stations_response.data.dig("features", 0)
      raise ApiError.new(message: "No observation stations found") unless station

      station_id = station.dig("properties", "stationIdentifier")
      response = connection.get("/stations/#{station_id}/observations/latest")
      raise_api_error(response) unless response.success?
      Response.new(response)
    rescue Faraday::Error => e
      raise ApiError.new(message: "API request failed: #{e.message}")
    end

    private

    def observation_stations_path(url)
      uri = URI.parse(url)
      raise ApiError.new(message: "Invalid observation stations URL: #{url}") unless uri.host == URI.parse(BASE_URL).host

      uri.path
    end

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

    # Method to handle API errors based on ProblemDetail
    def raise_api_error(response)
      return if response.success?

      begin
        error_data = JSON.parse(response.body)
      rescue JSON::ParserError
        raise ApiError.new(message: "API request failed with status #{response.status} but could not parse error response.")
      end
      
      raise ApiError.new(
        type: error_data["type"],
        title: error_data["title"],
        status: error_data["status"],
        detail: error_data["detail"],
        instance: error_data["instance"]
      )
    end    
  end
end
