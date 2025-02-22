# frozen_string_literal: true

RSpec.describe WeatherGovApi do
  it "has a version number" do
    expect(WeatherGovApi::VERSION).not_to be_nil
  end
end
