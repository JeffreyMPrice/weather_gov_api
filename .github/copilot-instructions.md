
# GitHub Copilot Instructions for WeatherGov Ruby Client

This document provides explicit instructions for GitHub Copilot to ensure that all generated code, configuration, and documentation meet the project's extremely high standards. These instructions are designed to maximize the quality, consistency, and reliability of Copilot's output while aligning with the project's goals and requirements.

---

## **1. General Principles**

1. **Adherence to Requirements**:
   - Always reference [`docs/PRD.md`](../docs/PRD.md) and [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) as the **definitive sources of truth** for requirements, scope, and architectural design.
   - If requirements or architectural details are ambiguous or incomplete, **ask for clarification** before proceeding.

2. **Code Quality**:
   - All generated code must be **production-ready**, **secure**, **resilient**, **scalable**, **modular**, and **reusable**.
   - Avoid introducing **Technical Debt** by adhering to best practices and project standards.

3. **Testing**:
   - All functionality must be thoroughly **unit-tested** using `RSpec`.
   - Ensure 100% test coverage and include tests for edge cases, error handling, and performance.

4. **Documentation**:
   - All public methods, classes, and modules must be documented using **YARD**.
   - Include examples in the documentation where applicable.

---

## **2. Coding Standards**

### **Follow the Style Guide**

- Adhere strictly to the project's [STYLE_GUIDE.md](../docs/STYLE_GUIDE.md).
- Use `RuboCop` for linting and formatting. Ensure all generated code passes `rubocop` checks.

### **Reference the Architecture**

- Follow the architectural guidelines outlined in [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md).
- Ensure that all components, interactions, and data flows align with the architecture's high-level design and component responsibilities.

### **Naming Conventions**

- Use `snake_case` for variables and methods.
- Use `CamelCase` for class and module names.
- Use `snake_case` for file names.

### **Error Handling**

- Use custom error classes defined in the `WeatherGovApi::Error` hierarchy.
- Log errors with detailed context using the project's logging conventions.

### **Security**

- Validate all inputs to prevent injection attacks or malformed requests.
- Use HTTPS for all API requests.
- Avoid hardcoding sensitive data (e.g., API keys); use environment variables instead.

---

## **3. File Structure**

Ensure that generated code is placed in the correct directory:

```text
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
└── STYLE_GUIDE.md         # Style Guide
```

---

## **4. Testing Requirements**

- Write unit tests for all generated functionality using `RSpec`.
- Mock external API calls using `WebMock` or `VCR`.
- Ensure 100% test coverage with `SimpleCov`.
- Include tests for:
  - Valid and invalid inputs.
  - Edge cases (e.g., boundary values for latitude/longitude).
  - Error handling (e.g., API downtime, invalid responses).
  - Performance and caching behavior.

---

## **5. Documentation Standards**

- Use **YARD** for documenting all public methods, classes, and modules.
- Include examples in the documentation where applicable.
- Ensure documentation is clear, concise, and aligned with the project's goals.

### **Example YARD Documentation**

```ruby
# Fetches the weather forecast for a given location.
#
# @param latitude [Float] The latitude of the location.
# @param longitude [Float] The longitude of the location.
# @return [Forecast] The weather forecast.
# @raise [WeatherGovApi::InvalidInputError] If the input is invalid.
def fetch_forecast(latitude, longitude)
  # ...
end
```

---

## **6. Pull Request Standards**

When generating code for a pull request, ensure the following:

1. **Small, Focused PRs**:
   - Address a single issue or enhancement per PR.
   - Link the PR to the relevant issue (e.g., `Closes #123`).

2. **Commit Messages**:
   - Write concise, informative commit messages.
   - Follow [Conventional Commits](https://www.conventionalcommits.org/) if applicable.

3. **PR Descriptions**:
   - Write clear, detailed PR descriptions explaining the **what** and **why** of the change.
   - Use the following template:

     ```markdown
     **What does this PR do?**
     A brief description of the changes made.

     **Why is this needed?**
     Explain the problem this PR solves or the feature it adds.

     **How does it work?**
     Provide an overview of the implementation.

     **Related Issues**
     Link to any related issues (e.g., `Closes #123`).

     **Testing**
     Describe how the changes were tested.
     ```

4. **Testing and Linting**:
   - Ensure all tests pass and all code adheres to the style guide.

---

## **7. Tips for Using Copilot**

- **Be Specific**: When writing prompts for Copilot, include as much detail as possible about the desired functionality.
- **Iterate**: If Copilot's suggestions are not accurate, refine your prompt or provide additional context.
- **Review Generated Code**: Always review and test code generated by Copilot to ensure it meets the project's standards.

---

## **8. Examples of Good Prompts**

### **Example 1: Fetching Weather Data**

```plaintext
Write a method `fetch_forecast` in the `WeatherClient` class that retrieves weather data from the weather.gov API for a given latitude and longitude. Use the `Faraday` gem for HTTP requests and handle errors using the `WeatherGovApi::Error` hierarchy.
```

### **Example 2: Writing a Unit Test**

```plaintext
Write an RSpec test for the `fetch_forecast` method in the `WeatherClient` class. Mock the HTTP request using `WebMock` and test both successful and error responses.
```

---

## **9. Asking for Clarification**

If requirements or architectural details are ambiguous or incomplete:

1. **Ask for Clarification**:
   - Request additional details or examples to clarify the requirements.
   - Example: "Should the `fetch_forecast` method handle retries for failed API requests, or should this be left to the calling application?"

2. **Reference Documentation**:
   - Refer to [`docs/PRD.md`](../docs/PRD.md) and [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) for additional context.

---

## **10. Additional Resources**

- [STYLE_GUIDE.md](../docs/STYLE_GUIDE.md)
- [CONTRIBUTING.md](../CONTRIBUTING.md)
- [ARCHITECTURE.md](../docs/ARCHITECTURE.md)
- [RuboCop Ruby Style Guide](https://rubystyle.guide/)
- [RSpec Documentation](https://rspec.info/documentation/)
- [YARD Documentation](https://yardoc.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Faraday Documentation](https://lostisland.github.io/faraday/)
