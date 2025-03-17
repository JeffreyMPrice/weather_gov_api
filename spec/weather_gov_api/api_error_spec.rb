# frozen_string_literal: true

require "spec_helper"

RSpec.describe WeatherGovApi::ApiError do
  describe "#initialize" do
    # rubocop:disable RSpec/MultipleExpectations
    it "sets the attributes correctly" do
      error = described_class.new(
        type: "https://api.weather.gov/problems/InvalidPoint",
        title: "Invalid Point",
        status: 400,
        detail: "The requested point is not valid.",
        instance: "https://api.weather.gov/requests/123",
        correlation_id: "abc-123",
        message: "Custom message"
      )

      expect(error.type).to eq("https://api.weather.gov/problems/InvalidPoint")
      expect(error.title).to eq("Invalid Point")
      expect(error.status).to eq(400)
      expect(error.detail).to eq("The requested point is not valid.")
      expect(error.instance).to eq("https://api.weather.gov/requests/123")
      expect(error.correlation_id).to eq("abc-123")
      expect(error.message).to eq("Custom message")
    end
    # rubocop:enable RSpec/MultipleExpectations

    it "defaults to title or detail as message if no message is provided" do
      error1 = described_class.new(title: "Invalid Point", detail: "The requested point is not valid.")
      expect(error1.message).to eq("Invalid Point")

      error2 = described_class.new(detail: "The requested point is not valid.")
      expect(error2.message).to eq("The requested point is not valid.")

      error3 = described_class.new
      expect(error3.message).to eq("API request failed")
    end
  end

  describe "#to_s" do
    it "returns a string representation including non-nil attributes" do
      error = described_class.new(
        type: "https://api.weather.gov/problems/InvalidPoint",
        title: "Invalid Point",
        status: 400,
        detail: "The requested point is not valid.",
        instance: "https://api.weather.gov/requests/123",
        correlation_id: "abc-123"
      )

      expect(error.to_s).to eq("Invalid Point")
    end

    it "excludes nil attributes from the string" do
      error = described_class.new(
        title: "Invalid Point",
        status: 400
      )

      expected_string = "Invalid Point"
      expect(error.to_s).to eq(expected_string)
    end

    it "works when nothing is passed in" do
      error = described_class.new

      expected_string = "API request failed"
      expect(error.to_s).to eq(expected_string)
    end
  end
end
