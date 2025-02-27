# frozen_string_literal: true

module WeatherGovApi
  module Errors
    # Custom error class to handle errors from the Weather.gov API
    class ApiError < StandardError
      attr_reader :type, :title, :status, :detail, :instance

      def initialize(type: nil, title: nil, status: nil, detail: nil, instance: nil, correlation_id: nil, message: message )
        @type = type
        @title = title
        @status = status
        @detail = detail
        @instance = instance
        @correlation_id = correlation_id
        @message = message
        super(message || title || detail || "API request failed")
      end

      def to_s
        "#{super} - Type: #{@type}, Title: #{@title}, Status: #{@status}, Detail: #{@detail}, Instance: #{@instance}, CorrelationID: #{@correlation_id}"
      end
    end
  end
end