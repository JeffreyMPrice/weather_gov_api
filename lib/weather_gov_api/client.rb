module WeatherGovApi

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

    private

    def validate_coordinates(latitude, longitude)
      unless latitude.between?(-90, 90)
        raise ArgumentError, "Invalid latitude: must be between -90 and 90"
      end

      unless longitude.between?(-180, 180)
        raise ArgumentError, "Invalid longitude: must be between -180 and 180"
      end
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
