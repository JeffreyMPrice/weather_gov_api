# frozen_string_literal: true

require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Test User Agent") }

  describe "#initialize" do
    it "sets a custom user agent" do
      expect(client.instance_variable_get(:@user_agent)).to eq("Test User Agent")
    end

    it "sets a default user agent when none provided" do
      default_client = described_class.new
      expect(default_client.instance_variable_get(:@user_agent))
        .to eq("WeatherGovApi Ruby Gem (#{WeatherGovApi::VERSION})")
    end
  end

  describe "API interactions" do
    context "when getting points data" do
      let(:latitude) { 39.7456 }
      let(:longitude) { -97.0892 }
      let(:endpoint) { "https://api.weather.gov/points/#{latitude},#{longitude}" }
      let(:headers) do
        {
          "Accept" => "application/json",
          "User-Agent" => "Test User Agent"
        }
      end

      it "fetches weather data for specific coordinates" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(
            status: 200,
            body: fixture("points_response.json"),
            headers: { "Content-Type" => "application/json" }
          )

        response = client.points(latitude: latitude, longitude: longitude)
        expect(response).to be_success
        expect(response.data).to include("properties")
      end

      it "handles 404 errors for invalid coordinates" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(
            status: 404,
            body: '{"detail": "No points found for coordinates"}',
            headers: { "Content-Type" => "application/json" }
          )

        response = client.points(latitude: latitude, longitude: longitude)
        expect(response).not_to be_success
        expect(response.status).to eq(404)
      end

      it "raises an error for network timeouts" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_timeout

        expect do
          client.points(latitude: latitude, longitude: longitude)
        end.to raise_error(WeatherGovApi::Error, /API request failed/)
      end

      it "raises an error for network connection errors" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_raise(Faraday::ConnectionFailed.new("Failed to connect"))

        expect do
          client.points(latitude: latitude, longitude: longitude)
        end.to raise_error(WeatherGovApi::Error, /API request failed/)
      end

      it "handles server errors (500)" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(
            status: 500,
            body: '{"detail": "Internal Server Error"}',
            headers: { "Content-Type" => "application/json" }
          )

        response = client.points(latitude: latitude, longitude: longitude)
        expect(response).not_to be_success
        expect(response.status).to eq(500)
      end

      it "validates coordinate inputs" do
        expect do
          client.points(latitude: 91, longitude: longitude)
        end.to raise_error(ArgumentError, /Invalid latitude/)

        expect do
          client.points(latitude: latitude, longitude: 181)
        end.to raise_error(ArgumentError, /Invalid longitude/)
      end

      # rubocop:disable RSpec/ExampleLength
      it "handles non-US coordinates" do
        non_us_latitude = 48.8575
        non_us_longitude = 2.3514
        non_us_endpoint = "https://api.weather.gov/points/#{non_us_latitude},#{non_us_longitude}"

        stub_request(:get, non_us_endpoint)
          .with(headers: headers)
          .to_return(
            status: 404,
            body: {
              correlationId: "1b57faad",
              title: "Data Unavailable For Requested Point",
              type: "https://api.weather.gov/problems/InvalidPoint",
              status: 404,
              detail: "Unable to provide data for requested point #{non_us_latitude},#{non_us_longitude}",
              instance: "https://api.weather.gov/requests/1b57faad"
            }.to_json,
            headers: { "Content-Type" => "application/json" }
          )

        response = client.points(latitude: non_us_latitude, longitude: non_us_longitude)
        expect(response).not_to be_success
        expect(response.status).to eq(404)
        expect(response.data["type"]).to eq("https://api.weather.gov/problems/InvalidPoint")
        expect(response.data["title"]).to eq("Data Unavailable For Requested Point")
      end
      # rubocop:enable RSpec/ExampleLength
    end

    describe "#observation_stations" do
      let(:points_response) do
        {
          "properties" => {
            "observationStations" => "https://api.weather.gov/gridpoints/TOP/31,80/stations"
          }
        }
      end

      let(:stations_response) do
        {
          "features" => [
            {
              "properties" => {
                "stationIdentifier" => "KTOP",
                "name" => "TOPEKA FORBES FIELD"
              }
            }
          ]
        }
      end

      it "fetches observation stations for given coordinates" do
        stub_request(:get, "https://api.weather.gov/points/39.0693,-95.6245")
          .to_return(status: 200, body: points_response.to_json)

        stub_request(:get, "https://api.weather.gov/gridpoints/TOP/31,80/stations")
          .to_return(status: 200, body: stations_response.to_json)

        response = client.observation_stations(latitude: 39.0693, longitude: -95.6245)
        expect(response.data["features"].first["properties"]["stationIdentifier"]).to eq("KTOP")
      end

      it "raises error when stations URL is not found in points response" do
        stub_request(:get, "https://api.weather.gov/points/39.0693,-95.6245")
          .to_return(status: 200, body: { "properties" => {} }.to_json)

        expect do
          client.observation_stations(latitude: 39.0693, longitude: -95.6245)
        end.to raise_error(WeatherGovApi::Error, "No observation stations URL found in points response")
      end

      it "raises error when stations URL is from a different domain" do
        points_response_with_bad_url = {
          "properties" => {
            "observationStations" => "https://malicious.com/stations"
          }
        }

        stub_request(:get, "https://api.weather.gov/points/39.0693,-95.6245")
          .to_return(status: 200, body: points_response_with_bad_url.to_json)

        expect do
          client.observation_stations(latitude: 39.0693, longitude: -95.6245)
        end.to raise_error(WeatherGovApi::Error, "Invalid observation stations URL: https://malicious.com/stations")
      end
    end

    describe "#current_weather" do
      let(:points_response) do
        {
          "properties" => {
            "observationStations" => "https://api.weather.gov/gridpoints/TOP/31,80/stations"
          }
        }
      end

      let(:stations_response) do
        {
          "features" => [
            {
              "properties" => {
                "stationIdentifier" => "KTOP",
                "name" => "TOPEKA FORBES FIELD"
              }
            }
          ]
        }
      end

      let(:weather_response) do
        {
          "properties" => {
            "temperature" => {
              "value" => 22.8,
              "unitCode" => "unit:degC"
            }
          }
        }
      end

      it "fetches current weather for given coordinates" do
        stub_request(:get, "https://api.weather.gov/points/39.0693,-95.6245")
          .to_return(status: 200, body: points_response.to_json)

        stub_request(:get, "https://api.weather.gov/gridpoints/TOP/31,80/stations")
          .to_return(status: 200, body: stations_response.to_json)

        stub_request(:get, "https://api.weather.gov/stations/KTOP/observations/latest")
          .to_return(status: 200, body: weather_response.to_json)

        response = client.current_weather(latitude: 39.0693, longitude: -95.6245)
        expect(response.data["properties"]["temperature"]["value"]).to eq(22.8)
      end

      it "raises error when no stations are found" do
        stub_request(:get, "https://api.weather.gov/points/39.0693,-95.6245")
          .to_return(status: 200, body: points_response.to_json)

        stub_request(:get, "https://api.weather.gov/gridpoints/TOP/31,80/stations")
          .to_return(status: 200, body: { "features" => [] }.to_json)

        expect do
          client.current_weather(latitude: 39.0693, longitude: -95.6245)
        end.to raise_error(WeatherGovApi::Error, "No observation stations found")
      end
    end
  end
end
