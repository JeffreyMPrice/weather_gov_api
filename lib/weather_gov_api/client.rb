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
      response = connection.get("/points/#{latitude},#{longitude}")
      raise_api_error(response) unless response.success?
      Response.new(response)
    rescue Faraday::Error => e
      raise WeatherGovApi::ApiError.new(message: "API request failed: #{e.message}")
    end

    # rubocop:disable Metrics/MethodLength
    def observation_stations(latitude:, longitude:)
      points_response = points(latitude: latitude, longitude: longitude)
      stations_url = points_response.data.dig("properties", "observationStations")
      unless stations_url
        raise WeatherGovApi::ApiError.new(message: "No observation stations URL found in points response")
      end

      stations_path = observation_stations_path(stations_url)

      response = connection.get(stations_path)
      raise_api_error(response) unless response.success?
      Response.new(response)
    rescue Faraday::Error => e
      raise WeatherGovApi::ApiError.new(message: "API request failed: #{e.message}")
    end
    # rubocop:enable Metrics/MethodLength

    def current_weather(latitude:, longitude:)
      stations_response = observation_stations(latitude: latitude, longitude: longitude)
      station = stations_response.data.dig("features", 0)
      raise WeatherGovApi::ApiError.new(message: "No observation stations found") unless station

      station_id = station.dig("properties", "stationIdentifier")
      response = connection.get("/stations/#{station_id}/observations/latest")
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
        faraday.adapter Faraday.default_adapter
      end
    end

    # rubocop:disable Metrics/MethodLength
    def raise_api_error(response)
      return if response.success?

      begin
        error_data = JSON.parse(response.body)
      rescue JSON::ParserError
        raise WeatherGovApi::ApiError.new(message: "API request failed with status #{response.status}\
            but could not parse error response.")
      end

      raise WeatherGovApi::ApiError.new(
        type: error_data["type"],
        title: error_data["title"],
        status: error_data["status"],
        detail: error_data["detail"],
        instance: error_data["instance"]
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
