# frozen_string_literal: true

require "spec_helper"
require "faraday"
require "weather_gov_api/errors"
require "weather_gov_api/middleware/error_handler"

RSpec.describe WeatherGovApi::Middleware::ErrorHandler do
  let(:app) { ->(env) { Faraday::Response.new(env) } }
  let(:middleware) { described_class.new(app) }

  def env_with(status:, body: "")
    Faraday::Env.new.tap do |env|
      env.status = status
      env.body = body
    end
  end

  it "raises ClientError for 4xx responses" do
    env = env_with(status: 404, body: '{"detail":"Not Found"}')
    expect { middleware.on_complete(env) }
      .to raise_error(WeatherGovApi::ClientError, include("Not Found"))
  end

  it "raises ServerError for 5xx responses" do
    env = env_with(status: 500, body: '{"detail":"Internal Server Error"}')
    expect { middleware.on_complete(env) }
      .to raise_error(WeatherGovApi::ServerError, include("Internal Server Error"))
  end

  it "raises NetworkError for Faraday::TimeoutError" do
    env = env_with(status: 200)
    allow(app).to receive(:call).and_raise(Faraday::TimeoutError, "timeout")
    expect do
      middleware.call(env)
    end.to raise_error(WeatherGovApi::NetworkError, include("timeout"))
  end

  it "raises ServerError for generic Faraday::Error" do
    env = env_with(status: 200)
    allow(app).to receive(:call).and_raise(Faraday::Error, "boom")
    expect do
      middleware.call(env)
    end.to raise_error(WeatherGovApi::ServerError, include("boom"))
  end
end
