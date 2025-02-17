# frozen_string_literal: true

require_relative "weather_gov_api/version"
require "faraday"
require "json"

module WeatherGovApi
  class Error < StandardError; end
  
  class Client
    BASE_URL = "https://api.weather.gov"
    
    def initialize(user_agent: nil)
      @user_agent = user_agent || "WeatherGovApi Ruby Gem (#{WeatherGovApi::VERSION})"
    end

    private

    def connection
      @connection ||= Faraday.new(url: BASE_URL) do |faraday|
        faraday.headers["User-Agent"] = @user_agent
        faraday.headers["Accept"] = "application/json"
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
