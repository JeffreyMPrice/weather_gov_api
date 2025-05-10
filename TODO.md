# TODO List for WeatherGov Ruby Client

This document outlines the next steps and user stories to bring the WeatherGov
Ruby Client up to the standards defined in the project documentation.

---

## **User Stories**

1. **Validate Latitude and Longitude Inputs**
   - As a developer, I want to validate latitude and longitude inputs to ensure
   they fall within acceptable ranges (latitude: -90 to 90, longitude: -180
   to 180) before making API requests.

2. **Implement Structured Logging**
   - As a developer, I want to add structured logging in JSON format for all API
   requests and responses, including timestamps, log levels, and contextual information.

3. **Mock API Responses in Tests**
   - As a developer, I want to use `WebMock` or `VCR` to mock API responses in
   RSpec tests, ensuring no real API calls are made during testing.

4. **Add Caching for API Responses**
   - As a developer, I want to implement an in-memory caching mechanism to store
   API responses for the lifetime of the client instance, reducing redundant API
   calls.

5. **Document All Public Methods Using YARD**
   - As a developer, I want to add YARD documentation for all public methods,
   including parameter descriptions, return types, and usage examples.

6. **Enforce HTTPS for All API Requests**
   - As a developer, I want to ensure that all API requests use HTTPS and fail
   gracefully if a non-secure connection is attempted.

7. **Achieve 100% Unit Test Coverage**
   - As a developer, I want to write unit tests for all existing methods and
   components, ensuring edge cases and error handling are thoroughly tested.

8. **Include a `User-Agent` Header in API Requests**
   - As a developer, I want to add a `User-Agent` header to all API requests,
   including the client version and a contact email address, as required by weather.gov.

9. **Implement Custom Error Classes**
   - As a developer, I want to create a hierarchy of custom error classes (e.g.,
   `ClientError`, `ServerError`, `NetworkError`) to handle different types of
   errors consistently.

10. **Validate API Responses**
    - As a developer, I want to validate that API responses conform to expected
    formats before transforming them into Ruby objects, raising errors for
    malformed or unexpected data.
11. **Transform API Responses into Ruby Objects**
    - As a developer, I want API responses to be converted into plain Ruby objects (POROs) like `Forecast` and `Alert`, providing a consistent and easy-to-use interface.

12. **Implement Retry Logic for Transient Failures**
    - As a developer, I want the client to automatically retry API requests with exponential backoff for transient network errors, improving resilience.

---

## **Next Steps**

- Prioritize the above user stories based on project milestones and timelines.
- Assign tasks to contributors and track progress using GitHub Issues or a
project board.
- Regularly review and update this TODO list as new requirements or improvements
are identified.
