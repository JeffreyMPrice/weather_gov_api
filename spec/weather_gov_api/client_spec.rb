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
    context "getting points data" do
      let(:latitude) { 39.7456 }
      let(:longitude) { -97.0892 }
      let(:endpoint) { "https://api.weather.gov/points/#{latitude},#{longitude}" }
      let(:headers) do
        {
          'Accept' => 'application/json',
          'User-Agent' => 'Test User Agent'
        }
      end

      it "fetches weather data for specific coordinates" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(
            status: 200,
            body: fixture("points_response.json"),
            headers: { 'Content-Type' => 'application/json' }
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
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.points(latitude: latitude, longitude: longitude)
        expect(response).not_to be_success
        expect(response.status).to eq(404)
      end

      it "raises an error for network timeouts" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_timeout

        expect {
          client.points(latitude: latitude, longitude: longitude)
        }.to raise_error(WeatherGovApi::Error, /API request failed/)
      end

      it "raises an error for network connection errors" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_raise(Faraday::ConnectionFailed.new("Failed to connect"))

        expect {
          client.points(latitude: latitude, longitude: longitude)
        }.to raise_error(WeatherGovApi::Error, /API request failed/)
      end

      it "handles server errors (500)" do
        stub_request(:get, endpoint)
          .with(headers: headers)
          .to_return(
            status: 500,
            body: '{"detail": "Internal Server Error"}',
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.points(latitude: latitude, longitude: longitude)
        expect(response).not_to be_success
        expect(response.status).to eq(500)
      end

      it "validates coordinate inputs" do
        expect {
          client.points(latitude: 91, longitude: longitude)
        }.to raise_error(ArgumentError, /Invalid latitude/)

        expect {
          client.points(latitude: latitude, longitude: 181)
        }.to raise_error(ArgumentError, /Invalid longitude/)
      end

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
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.points(latitude: non_us_latitude, longitude: non_us_longitude)
        expect(response).not_to be_success
        expect(response.status).to eq(404)
        expect(response.data["type"]).to eq("https://api.weather.gov/problems/InvalidPoint")
        expect(response.data["title"]).to eq("Data Unavailable For Requested Point")
      end
    end
  end
end 