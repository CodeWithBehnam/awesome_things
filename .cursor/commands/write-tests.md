# Write Tests

Generate comprehensive test suites for the selected code or current file.

## Purpose
Create thorough test coverage including unit tests, integration tests, and edge cases to ensure code reliability and maintainability.

## Instructions
1. **Test Analysis**:
   - Identify all public functions, methods, and components
   - Determine testable units and their dependencies
   - Analyse input/output requirements and edge cases
   - Review existing test patterns in the project

2. **Test Implementation**:
   - Write unit tests for each public function/method
   - Include positive test cases (happy path)
   - Add negative test cases (error conditions)
   - Create edge case tests (boundary conditions)
   - Add integration tests for complex interactions

3. **Test Quality Standards**:
   - Use descriptive test names that explain the scenario
   - Follow AAA pattern (Arrange, Act, Assert)
   - Include proper setup and teardown
   - Ensure test isolation and independence
   - Add appropriate assertions and expectations

4. **Framework-Specific Implementation**:
   - **JavaScript/TypeScript**: Use Jest, Vitest, or Mocha
   - **Python**: Use pytest or unittest
   - **React**: Use React Testing Library and Jest
   - **Node.js**: Use Jest or Mocha with appropriate assertions
   - **Backend APIs**: Include request/response testing

5. **Coverage and Documentation**:
   - Aim for high test coverage (80%+ for critical paths)
   - Add test documentation and comments
   - Include performance tests where appropriate
   - Document test data and mock strategies

## Examples
- **Test React component**: `/write-tests` on component file
- **Test API endpoint**: `/write-tests` on route handler
- **Test utility function**: `/write-tests` on utility file
- **Test service class**: `/write-tests` on service implementation

## Constraints
- Follow the project's existing testing framework and patterns
- Ensure tests are maintainable and not overly complex
- Include proper mocking for external dependencies
- Consider test execution time and performance
- Make tests deterministic and repeatable