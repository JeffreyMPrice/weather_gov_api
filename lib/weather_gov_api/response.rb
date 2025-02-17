# frozen_string_literal: true

module WeatherGovApi
  class Response
    attr_reader :status, :data

    def initialize(response)
      @status = response.status
      @data = JSON.parse(response.body)
    end

    def success?
      status >= 200 && status < 300
    end
  end
end 