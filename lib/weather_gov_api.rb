# frozen_string_literal: true

require_relative "weather_gov_api/version"
require_relative "weather_gov_api/api_errors"
require_relative "weather_gov_api/response"
require_relative "weather_gov_api/client"

require "faraday"
require "json"

module WeatherGovApi
  class Error < StandardError; end
end
