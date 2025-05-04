# frozen_string_literal: true

require "weather_gov_api"
require "json"
require "simplecov"
require "simplecov-cobertura"
require "debug"
require "factory_bot"

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

Dir[File.expand_path("support/**/*.rb", __dir__)].each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include FactoryBot::Syntax::Methods
  # Automatically load all factories in the spec/factories directory
  FactoryBot.definition_file_paths = [File.expand_path("factories", __dir__)]
  FactoryBot.find_definitions
end

def fixture_path
  File.expand_path("fixtures", __dir__)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end
