# frozen_string_literal: true

module WeatherGovApi
  module Middleware
    # Faraday middleware for handling and categorizing errors from the weather.gov API.
    #
    # This middleware inspects HTTP responses and raises custom error classes
    # based on the status code or network failure. It ensures that all errors
    # are consistently categorized and surfaced to the user as WeatherGovApi errors.
    #
    # @example Usage in Faraday connection
    #   Faraday.new(url: BASE_URL) do |faraday|
    #     faraday.use WeatherGovApi::Middleware::ErrorHandler
    #     faraday.adapter Faraday.default_adapter
    #   end
    #
    # @raise [WeatherGovApi::ClientError] for 4xx errors
    # @raise [WeatherGovApi::ServerError] for 5xx errors or Faraday::Error
    # @raise [WeatherGovApi::NetworkError] for network failures (timeouts, connection errors)
    class ErrorHandler < Faraday::Middleware
      # Handles the HTTP response after completion.
      #
      # @param env [Faraday::Env] The Faraday request environment.
      # @raise [WeatherGovApi::ClientError] for 4xx errors.
      # @raise [WeatherGovApi::ServerError] for 5xx errors.
      # rubocop:disable Metrics/MethodLength, Metrics/CyclomaticComplexity
      def on_complete(env)
        puts "[DEBUG] WeatherGovApi::Middleware::ErrorHandler called with status: #{env.status}"

        status = env.status
        body = env.body

        # Try to parse error details if present
        error_detail = begin
          data = JSON.parse(body) if body.is_a?(String) && body.strip.start_with?("{")
          data["detail"] || data["title"]
        rescue StandardError
          nil
        end

        case status
        when 400..499
          raise WeatherGovApi::ClientError, error_detail || "Client error (#{status})"
        when 500..599
          raise WeatherGovApi::ServerError, error_detail || "Server error (#{status})"
        end
      end

      # Handles network and Faraday errors, raising custom error classes.
      #
      # @param env [Faraday::Env] The Faraday request environment.
      # @raise [WeatherGovApi::NetworkError] for network failures.
      # @raise [WeatherGovApi::ServerError] for other Faraday errors.
      def call(env)
        @app.call(env).on_complete do |response_env|
          on_complete(response_env)
        end
      rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
        raise WeatherGovApi::NetworkError, "Network error: #{e.message}"
      rescue Faraday::Error => e
        raise WeatherGovApi::ServerError, "API request failed: #{e.message}"
      end
    end
    # rubocop:enable Metrics/MethodLength, Metrics/CyclomaticComplexity
  end
end
