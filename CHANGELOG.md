# Changelog

## [0.2.2] - 2025-02-21
- tackled rubocop_todo list

## [0.2.1] - 2025-02-21
- added rubocop_todo
- added simplecov and rubycritic
- updated CircleCI to require 90% overall and 80% on a file for test coverage

## [0.2.0] - 2025-02-19

### Added
- `observation_stations` method to fetch nearby weather stations
- `current_weather` method to fetch latest weather data from the closest station

## [0.1.0] - Initial Release

### Added
- Basic client implementation for weather.gov API
- `points` method for fetching weather data by coordinates
  - Error handling for:
  - Non-US coordinates
  - Network timeouts
  - Invalid coordinates
  - Server errors
- Documentation for basic usage
- CircleCI integration
