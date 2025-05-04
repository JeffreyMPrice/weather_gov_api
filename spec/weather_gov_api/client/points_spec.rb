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

  # rubocop:disable RSpec/MultipleMemoizedHelpers
  describe "#points" do
    let(:latitude) { 39.7456 }
    let(:longitude) { -97.0892 }
    let(:endpoint) { "/points/#{latitude},#{longitude}" }
    let(:points_response) { build(:points_response, grid_id: "TOP", grid_x: 31, grid_y: 80) }
    let(:non_us_points_response) { build(:points_response, :non_us_coordinates) }
    let(:invalid_points_response) { build(:points_response, :invalid_coordinates) }

    it "fetches weather data for specific coordinates" do
      stubs.get(endpoint) do
        [
          200,
          default_headers,
          points_response.to_json
        ]
      end

      response = client.points(latitude: latitude, longitude: longitude)
      expect(response).to be_success
      expect(response.data).to include("properties")

      stubs.verify_stubbed_calls
    end

    it "raises an error for invalid coordinates" do
      invalid_latitude = 9.7456
      invalid_longitude = -200.0892
      invalid_endpoint = "/points/#{invalid_latitude},#{invalid_longitude}"

      stubs.get(invalid_endpoint) do
        [
          400,
          default_headers,
          invalid_points_response.to_json
        ]
      end

      expect do
        client.points(latitude: invalid_latitude, longitude: invalid_longitude)
      end.to raise_error(WeatherGovApi::ApiError, "Invalid Parameter")

      stubs.verify_stubbed_calls
    end

    it "handles non-US coordinates" do
      non_us_latitude = 48.8575
      non_us_longitude = 2.3514
      non_us_endpoint = "/points/#{non_us_latitude},#{non_us_longitude}"

      stubs.get(non_us_endpoint) do
        [
          404,
          default_headers,
          non_us_points_response.to_json
        ]
      end

      expect do
        client.points(latitude: non_us_latitude, longitude: non_us_longitude)
      end.to raise_error(WeatherGovApi::ApiError, "Data Unavailable For Requested Point")

      stubs.verify_stubbed_calls
    end
  end
  # rubocop:enable RSpec/MultipleMemoizedHelpers
end
# rubocop:enable RSpec/SpecFilePathFormat
