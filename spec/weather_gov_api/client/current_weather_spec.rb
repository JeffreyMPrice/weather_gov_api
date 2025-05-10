# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat

require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Test User Agent") }

  describe "#current_weather", :vcr do
    let(:latitude) { 39.7456 }
    let(:longitude) { -97.0892 }


    it "returns a successful response with properties for valid US coordinates" do
      response = client.current_weather(latitude: latitude, longitude: longitude)
      expect(response).to be_success
      expect(response.data).to include("properties")
      expect(response.data["properties"]).to include("temperature")
    end

    it "raises a ClientError if no observation stations are found" do
      # Simulate no stations found in the observation_stations response
      allow_any_instance_of(WeatherGovApi::Client).to receive(:observation_stations)
        .and_return(double(data: { "features" => [] }))

      expect {
        client.current_weather(latitude: 0, longitude: 0)
      }.to raise_error(WeatherGovApi::ClientError, include("No observation stations found"))
    end

    it "raises a ClientError for invalid coordinates" do
      expect {
        client.current_weather(latitude: 91, longitude: 181)
      }.to raise_error(WeatherGovApi::ClientError)
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
