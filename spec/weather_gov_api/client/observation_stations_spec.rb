# frozen_string_literal: true

# rubocop:disable RSpec/SpecFilePathFormat
require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Test User Agent") }
  
  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe "#observation_stations", :vcr do
    include_context "with successful points request"
    let(:latitude) { 39.7456 }
    let(:longitude) { -97.0892 }

    it "returns a successful response with features for valid US coordinates" do
      response = client.observation_stations(latitude: latitude, longitude: longitude)
      expect(response).to be_success
      expect(response.data).to include("features")
      expect(response.data["features"]).to be_an(Array)
      expect(response.data["features"].first).to include("properties")
      expect(response.data["features"].first["properties"]).to include("stationIdentifier")
    end

    it "raises a ClientError if no observation stations URL is found in the points response" do
      # Simulate coordinates that will not return an observationStations property
      allow_any_instance_of(WeatherGovApi::Client).to receive(:points)
        .and_return(double(data: { "properties" => {} }))

      expect {
        client.observation_stations(latitude: 0, longitude: 0)
      }.to raise_error(WeatherGovApi::ClientError, include("No observation stations URL found"))
    end

    it "raises a ClientError for invalid coordinates" do
      expect {
        client.observation_stations(latitude: 91, longitude: 181)
      }.to raise_error(WeatherGovApi::ClientError)
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
# rubocop:enable RSpec/SpecFilePathFormat
