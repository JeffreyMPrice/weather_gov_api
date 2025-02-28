# frozen_string_literal: true

module WeatherGovApi
  # Custom error class to handle errors from the Weather.gov API
  class ApiError < StandardError
    attr_reader :type, :title, :status, :detail, :instance, :correlation_id, :parameter_errors

    # rubocop:disable Metrics/ParameterLists
    def initialize(type: nil, title: nil, status: nil, detail: nil, instance: nil, correlation_id: nil, message: nil,
                   parameter_errors: nil)
      @type = type
      @title = title
      @status = status
      @detail = detail
      @instance = instance
      @correlation_id = correlation_id
      @parameter_errors = parameter_errors
      @message = message
      super(message || title || detail || "API request failed")
    end
    # rubocop:enable Metrics/ParameterLists

    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def to_s
      return super unless super.empty?

      parts = []
      parts << "Type: #{@type}" if @type
      parts << "Title: #{@title}" if @title
      parts << "Status: #{@status}" if @status
      parts << "Detail: #{@detail}" if @detail
      parts << "Instance: #{@instance}" if @instance
      parts << "CorrelationID: #{@correlation_id}" if @correlation_id
      parts << "ParameterErros: #{@parameter_errors}" if @parameter_errors
      parts.join(", ")
    end
    # rubocop:enable Metrics/PerceivedComplexity
    # rubocop:enable Metrics/CyclomaticComplexity
  end
end
