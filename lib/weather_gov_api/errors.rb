# frozen_string_literal: true

module WeatherGovApi
  # Base error class for all WeatherGovApi errors.
  class Error < StandardError; end

  # Raised for 4xx client errors from the weather.gov API.
  class ClientError < Error; end

  # Raised for 5xx server errors from the weather.gov API.
  class ServerError < Error; end

  # Raised for network-related errors (timeouts, connection failures).
  class NetworkError < Error; end
end
