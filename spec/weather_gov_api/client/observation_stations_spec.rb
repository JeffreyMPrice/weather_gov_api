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

  describe "#observation_stations" do
    include_context "with successful points request"
    let(:latitude) { 39.7456 }
    let(:longitude) { -97.0892 }
    let(:grid_id) { "KMYZ" }

    let(:stations_response) { build(:stations_response, station_identifier: grid_id) }

    it "fetches observation stations for given coordinates" do
      stubs.get("/gridpoints/#{grid_id}/#{grid_x},#{grid_y}/stations") do
        [
          200,
          default_headers,
          stations_response.to_json
        ]
      end

      response = client.observation_stations(latitude: latitude, longitude: longitude)
      expect(response.data["features"].first["properties"]["stationIdentifier"]).to eq(grid_id)

      stubs.verify_stubbed_calls
    end

    context "when the points response is missing the stations URL" do
      let(:points_response_body) { { "properties" => {} } }

      it "raises an error if the stations URL is missing" do
        expect do
          client.observation_stations(latitude: latitude, longitude: longitude)
        end.to raise_error(WeatherGovApi::ApiError, "No observation stations URL found in points response")

        stubs.verify_stubbed_calls
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
