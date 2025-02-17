# frozen_string_literal: true

require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Ruby Gem WeatherGov API Agent") }

  describe "#initialize" do
    it "sets a custom user agent" do
      expect(client.instance_variable_get(:@user_agent)).to eq("Ruby Gem WeatherGov API Agent")
    end

    it "sets a default user agent when none provided" do
      default_client = described_class.new
      expect(default_client.instance_variable_get(:@user_agent))
        .to eq("WeatherGovApi Ruby Gem (#{WeatherGovApi::VERSION})")
    end
  end

  describe "API interactions" do
    # We'll add more tests here as we implement features
    context "getting points data" do
      it "fetches weather data for specific coordinates" do
        pending "Implement points endpoint"
        latitude = 39.7456
        longitude = -97.0892
        
        stub_request(:get, "https://api.weather.gov/points/39.7456,-97.0892")
          .with(
            headers: {
              'Accept' => 'application/json',
              'User-Agent' => 'Test User Agent'
            }
          )
          .to_return(
            status: 200,
            body: fixture("points_response.json"),
            headers: { 'Content-Type' => 'application/json' }
          )

        response = client.points(latitude: latitude, longitude: longitude)
        expect(response).to be_success
        expect(response.data).to include("properties")
      end
    end
  end
end 