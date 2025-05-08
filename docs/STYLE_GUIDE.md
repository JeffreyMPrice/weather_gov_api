# Style Guide (STYLE_GUIDE.md)

This style guide establishes clear, unambiguous rules for all developers and Coding LLMs working on the WeatherGov Ruby Client. It ensures consistency, readability, maintainability, and adherence to best practices, facilitating collaboration and delivering a high-performing, production-ready system.

---

## **1. General Principles**

1. **Consistency**: Follow the same patterns and conventions throughout the codebase.  
2. **Readability**: Write code that is easy to understand for other developers.  
3. **Maintainability**: Ensure the code is modular, reusable, and easy to refactor.  
4. **Security-First**: Prioritize secure coding practices to prevent vulnerabilities.  
5. **Avoid Technical Debt**: Write clean, well-documented code and refactor regularly.  

---

## **2. Linters and Formatters**

- **Linters**:
  - Use `RuboCop` for linting Ruby code.
  - Extend with the [RuboCop Ruby Style Guide](https://rubystyle.guide/) as the base configuration.
  - Include `rubocop-performance` and `rubocop-rspec` for performance and testing-specific rules.

- **Formatters**:
  - Use `RuboCop`'s auto-correct feature (`rubocop -A`) to enforce consistent formatting.

- **Configuration**:
  - Store linter configurations in `.rubocop.yml`.
  - Example `.rubocop.yml`:
    ```yaml
    inherit_gem:
      rubocop: rubocop.yml
      rubocop-performance: rubocop-performance.yml
      rubocop-rspec: rubocop-rspec.yml

    AllCops:
      TargetRubyVersion: 3.2
      NewCops: enable
      Exclude:
        - 'db/schema.rb'

    Layout/LineLength:
      Max: 100
    ```

---

## **3. Naming Conventions**

### **Variables**
- Use `snake_case` for variable and method names.
- Use `UPPER_SNAKE_CASE` for constants.

**Do**:
```ruby
user_name = "John"
API_KEY = ENV["API_KEY"]
```

**Don't**:
```ruby
UserName = "John"
apiKey = ENV["API_KEY"]
```

### **Classes and Modules**
- Use `CamelCase` for class and module names.

**Do**:
```ruby
class WeatherClient
end
```

**Don't**:
```ruby
class weather_client
end
```

### **Methods**
- Use `snake_case` for method names.
- Method names should clearly describe their purpose.
- **Do**:
```ruby
  def fetch_weather_data
    # ...
  end
```

**Don't**:
```ruby
def FetchWeather
  # ...
end
```


### **Files**
- Use `snake_case` for file names.
- Name files after the class or module they define.

**Do**:
```
weather_client.rb
```

**Don't**:
```
WeatherClient.rb
```

---

## **4. Folder Structure**

Adopt a modular folder structure for scalability and maintainability. Group related functionality together. For example:

```
lib/
├── weather_gov_api/       # Main library code
│   ├── client.rb          # Client interface
│   ├── errors.rb          # Error classes
│   ├── caching.rb         # Caching logic
│   ├── logging.rb         # Logging logic
│   └── transformations/   # Data transformation logic
spec/
├── weather_gov_api/       # Unit tests
│   ├── client_spec.rb
│   ├── errors_spec.rb
│   ├── caching_spec.rb
│   └── transformations/
docs/
├── PRD.md                 # Product Requirements Document
├── ARCHITECTURE.md        # Architecture Document
└── STYLE_GUIDE.md        # Style Guide```
```

### **Configuration Files**
- Place all configuration files (e.g., `.rubocop.yml`, `.rspec`, `Gemfile`) in the root directory.
- CI/CD scripts (e.g., `.circleci/config.yml`) should be placed in a `.circleci/` folder.

---

## **5. Component Design Patterns**

### **Classes and Methods**
- Use small, single-responsibility classes.
- Methods should do one thing and do it well.

**Do**:
```ruby
class ForecastFetcher
  def call
    # fetch and return forecast
  end
end
```

**Don't**:
```ruby
class Forecast
  def process_and_fetch_and_log_forecast
    # too much responsibility
  end
end
```

### **Error Handling**
- Raise custom errors for non-recoverable issues (e.g., invalid input, API failures).
- For recoverable errors, return error objects or codes.

**Do**:
  ```ruby
  raise WeatherGovApi::InvalidInputError, "Latitude must be between -90 and 90"
  ```

**Don't**:
```ruby
raise "Something went wrong"
```

---

## **6. Testing**

### **Unit Tests**
- Use RSpec for unit testing.
- Mock external API calls using WebMock or VCR.

### **Integration Tests**
- Test the interaction between components (e.g., HTTP layer and data transformation).

### **Test File Structure**
- Place unit tests in [weather_gov_api](http://_vscodecontentref_/4) and name files after the class being tested (e.g., `client_spec.rb`).
- Place integration tests in `spec/integration/`.

### **Test Scope**
- **Unit Tests**: Test individual methods or classes in isolation.
- **Integration Tests**: Test interactions between components (e.g., HTTP layer and data transformation).

### **Coverage**
- Use SimpleCov to ensure 100% test coverage.

---

## **7. Security Considerations**

- Validate all inputs (e.g., latitude and longitude ranges).
- Sanitize data before logging or displaying it.
- Use HTTPS for all API requests.
- Regularly audit dependencies with `bundler-audit` or `dependabot`.

### **Sensitive Data Handling**
- Store sensitive data (e.g., API keys) in environment variables.
- Use the `dotenv` gem for local development.
- **Do**:
  ```ruby
  API_KEY = ENV["WEATHER_API_KEY"]
  ```

- **Don't**
  ```
  API_KEY = "hardcoded_key"
  ```
---

## **8. Documentation Standards**

- Use YARD for generating documentation.
- Document all public methods, classes, and modules.
- Include examples for common use cases.

**Do**:
```ruby
# WeatherClient interacts with the weather.gov API to fetch weather data.
#
# Example:
#   client = WeatherClient.new
#   forecast = client.fetch_forecast(39.7456, -97.0892)
#
# @param lat [Float] The latitude
# @param lon [Float] The longitude
# @return [Forecast]
def fetch_forecast(lat, lon)
  # ...
end
```

**Don't**:
```ruby
# forecast method
def forecast(lat, lon)
end
```

---

## **9. Do's and Don'ts**

### **Do's**
- Write clean, modular, and reusable code.
- Follow the DRY (Don't Repeat Yourself) principle.
- Use meaningful variable and method names.
- Write comprehensive tests for all code.
- Use dependency injection for better testability.
- Write thread-safe code when using shared resources.


### **Don'ts**
- Avoid using `puts` or `print` for logging; use a logger instead.
- Don't leave TODO comments without a clear plan to address them.
- Avoid hardcoding values; use configuration files or environment variables.
- Avoid using global variables.
- Don't rescue generic exceptions (e.g., `rescue StandardError`).

---

## **10. References**

- [RuboCop Ruby Style Guide](https://rubystyle.guide/)
- [RSpec Documentation](https://rspec.info/documentation/)
- [YARD Documentation](https://rubydoc.info/gems/yard/)
- [Bundler Audit](https://github.com/rubysec/bundler-audit)
