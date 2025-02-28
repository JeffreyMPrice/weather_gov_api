# WeatherGovApi

A Ruby wrapper for the National Weather Service (weather.gov) API. This gem provides a simple interface to access weather data for US locations.

## Installation

Add the gem to your Gemfile:
```bash
bundle add weather_gov_api
```

If bundler is not being used to manage dependencies, install the gem by executing:
```bash
gem install weather_gov_api
```

## Usage

```ruby
require 'weather_gov_api'

client = WeatherGovApi::Client.new
response = client.get_forecast(latitude: 37.7749, longitude: -122.4194)
puts response.body
```

### Optionally, provide a custom User-Agent
```ruby
client = WeatherGovApi::Client.new(user_agent: 'MyApp/1.0')
```
## Available Methods

### points(latitude:, longitude:)
Fetches basic point data for the given coordinates.

### observation_stations(latitude:, longitude:)
Fetches a list of nearby weather observation stations.

### current_weather(latitude:, longitude:)
Fetches the current weather conditions from the closest observation station.


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

### Building and Releasing

1. Update the version number in `version.rb`
2. Build the gem:
   ```bash
   gem build weather_gov_api.gemspec
   ```
3. Test the built gem locally:
   ```bash
   gem install ./weather_gov_api-X.X.X.gem
   ```
4. Release to RubyGems:
   ```bash
   gem push weather_gov_api-X.X.X.gem
   ```

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JeffreyMPrice/weather_gov_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/JeffreyMPrice/weather_gov_api/blob/main/CODE_OF_CONDUCT.md).

## TODO

- [ ] Implement forecast retrieval functionality
- [ ] Add validation to limit latitude and longitude to 4 decimal places (weather.gov API requirement)
- [ ] Implement rate limiting strategies:
  - [ ] Local rate limiting
  - [ ] Distributed rate limiting (Redis/DB-based)
- [ ] Add caching support for API responses
- [ ] Automate CHANGELOG.md updates during release process

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WeatherGovApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/JeffreyMPrice/weather_gov_api/blob/main/CODE_OF_CONDUCT.md).
