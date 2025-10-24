## Description

<!-- Provide a brief description of the changes in this PR -->

## Type of Change

<!-- Mark the relevant option with an "x" -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update
- [ ] CI/CD or workflow improvement
- [ ] Dependency update
- [ ] Refactoring (no functional changes)

## Related Issues

<!-- Link related issues here -->

Fixes #(issue number)
Relates to #(issue number)

## Pre-Submission Checklist

<!-- Mark completed items with an "x" -->

### Code Quality

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] My changes generate no new warnings or errors

### Documentation

- [ ] I have updated the documentation accordingly
- [ ] All markdown files pass linting (`npx markdownlint "**/*.md"`)
- [ ] All links are valid and return 200 status codes
- [ ] No links point to non-existent files
- [ ] External URLs are verified and working

### Security

- [ ] No hardcoded secrets, API keys, or passwords in my code
- [ ] I have not committed sensitive information
- [ ] Lock files (`package-lock.json`, etc.) are not manually edited
- [ ] Secret references use proper GitHub Actions syntax (`${{ secrets.* }}`)

### Shell Scripts & Workflows

- [ ] Shell scripts use proper quote escaping (single quotes for literal strings)
- [ ] No unescaped backticks in grep patterns
- [ ] Secret scanning exclusions are properly configured
- [ ] Workflow YAML syntax is valid

### Testing

- [ ] I have tested my changes locally
- [ ] All CI/CD workflows pass
- [ ] No new security vulnerabilities introduced
- [ ] Changes do not break existing functionality

## Testing Instructions

<!-- Describe how reviewers can test your changes -->

```bash
# Steps to test
1. 
2. 
3. 
```

## Screenshots (if applicable)

<!-- Add screenshots to help explain your changes -->

## Additional Notes

<!-- Any additional information that reviewers should know -->

## Workflow Validation

<!-- Verify that all these workflows pass -->

- [ ] ✅ Lint and Validate
- [ ] ✅ Security Scan
- [ ] ✅ Health Check
- [ ] ✅ Generate Report

---

**By submitting this PR, I confirm that:**

- I have read and followed the [Contributing Guidelines](.github/CONTRIBUTING.md)
- My changes do not introduce security vulnerabilities
- All tests pass locally before pushing
- Documentation is updated and links are verified
