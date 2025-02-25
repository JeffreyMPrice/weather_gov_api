# frozen_string_literal: true

require "weather_gov_api"
require "webmock/rspec"
require "json"
require "simplecov"
require "simplecov-cobertura"
require "debug"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"

  enable_coverage :branch

  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::HTMLFormatter,
                                                       SimpleCov::Formatter::CoberturaFormatter
                                                     ])

  minimum_coverage 90
  minimum_coverage_by_file 80 # Optional: also enforce per-file minimum
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path
  File.expand_path("fixtures", __dir__)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end
