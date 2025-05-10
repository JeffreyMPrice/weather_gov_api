# frozen_string_literal: true

require "spec_helper"

RSpec.describe WeatherGovApi::Client do
  let(:client) { described_class.new(user_agent: "Test User Agent") }

  describe "#points", :vcr do
    let(:latitude) { 39.7456 }
    let(:longitude) { -97.0892 }

    it "returns a successful response with properties for valid US coordinates" do
      response = client.points(latitude: latitude, longitude: longitude)
      expect(response).to be_success
      expect(response.data).to include("properties")
    end

    it "raises an ClientError with a 'does not appear to be a valid coordinate' message for out-of-range longitude" do
      invalid_latitude = 9.7456
      invalid_longitude = -200.0892

      expect do
        client.points(latitude: invalid_latitude, longitude: invalid_longitude)
      end.to raise_error(WeatherGovApi::ClientError, include("does not appear to be a valid coordinate"))
    end

    it "raises an ClientError with an 'Unable to provide data for requested point' message for non-US coordinates" do
      non_us_latitude = 48.8575
      non_us_longitude = 2.3514

      expect do
        client.points(latitude: non_us_latitude, longitude: non_us_longitude)
      end.to raise_error(WeatherGovApi::ClientError, include("Unable to provide data for requested point"))
    end
  end
end
