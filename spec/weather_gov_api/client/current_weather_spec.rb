# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Test User Agent") }
  let(:stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:connection) { Faraday.new { |builder| builder.adapter :test, stubs } }
  let(:default_headers) do
    {
      "Accept" => "application/json",
      "User-Agent" => "Test User Agent"
    }
  end

  before do
    allow(client).to receive(:connection).and_return(connection)
  end

  describe "#current_weather" do
    let(:points_response) { build(:points_response) }
    let(:stations_response) { build(:stations_response) }
    let(:weather_response) { build(:weather_response) }

    it "fetches current weather for given coordinates" do
      stubs.get("/points/39.0693,-95.6245") do
        [
          200,
          default_headers,
          points_response.to_json
        ]
      end

      stubs.get("/gridpoints/TOP/31,80/stations") do
        [
          200,
          default_headers,
          stations_response.to_json
        ]
      end

      stubs.get("/stations/KTOP/observations/latest") do
        [
          200,
          default_headers,
          weather_response.to_json
        ]
      end

      response = client.current_weather(latitude: 39.0693, longitude: -95.6245)
      expect(response.data["properties"]["temperature"]["value"]).to eq(22.8)

      stubs.verify_stubbed_calls
    end

    it "raises an error when no stations are found" do
      stubs.get("/points/39.0693,-95.6245") do
        [
          200,
          default_headers,
          points_response.to_json
        ]
      end

      stubs.get("/gridpoints/TOP/31,80/stations") do
        [
          200,
          default_headers,
          { "features" => [] }.to_json
        ]
      end

      expect do
        client.current_weather(latitude: 39.0693, longitude: -95.6245)
      end.to raise_error(WeatherGovApi::ApiError, "No observation stations found")

      stubs.verify_stubbed_calls
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
