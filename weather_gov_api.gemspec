# frozen_string_literal: true

require_relative "lib/weather_gov_api/version"

Gem::Specification.new do |spec|
  spec.name = "weather_gov_api"
  spec.version = WeatherGovApi::VERSION
  spec.authors = ["JeffreyMPrice"]
  spec.email = ["108019276+JeffreyMPrice@users.noreply.github.com"]

  spec.summary = "Ruby wrapper for the Weather.gov API"
  spec.description = "A Ruby gem for accessing weather data from the National Weather Service (weather.gov) API.
    Provides a simple interface to fetch weather data for US locations."
  spec.homepage = "https://github.com/JeffreyMPrice/weather_gov_api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.end_with?(".gem") ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html

  spec.add_dependency "faraday", "~> 2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
