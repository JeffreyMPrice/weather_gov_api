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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JeffreyMPrice/weather_gov_api. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/JeffreyMPrice/weather_gov_api/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the WeatherGovApi project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/JeffreyMPrice/weather_gov_api/blob/main/CODE_OF_CONDUCT.md).
