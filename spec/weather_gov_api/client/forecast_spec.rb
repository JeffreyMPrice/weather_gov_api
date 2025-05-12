# frozen_string_literal: true

require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Test User Agent") }

  describe "#forecast", :vcr do
    let(:latitude) { 39.7456 }
    let(:longitude) { -97.0892 }

    it "returns a successful response with properties for valid US coordinates" do
      response = client.forecast(latitude: latitude, longitude: longitude)
      expect(response).to be_success
      periods = response.data["properties"]["periods"]
      expect(periods).not_to be_empty
      periods.each do |period|
        expect(period).to include("temperature")
        expect(period["temperature"]).to be_a(Numeric)
      end
    end

    it "raises a ClientError for out-of-range coordinates" do
      expect do
        client.forecast(latitude: 91, longitude: 181)
      end.to raise_error(WeatherGovApi::ClientError)
    end

    it "raises a ServerError for a 5xx API response" do
      # Simulate a server error by stubbing the connection
      allow(client).to receive(:points).and_call_original
      fake_connection = instance_double(Faraday::Connection)
      allow(fake_connection).to receive(:get).and_raise(WeatherGovApi::ServerError, "Internal Server Error")
      allow(client).to receive(:connection).and_return(fake_connection)

      expect do
        client.forecast(latitude: latitude, longitude: longitude)
      end.to raise_error(WeatherGovApi::ServerError)
    end
  end
end
