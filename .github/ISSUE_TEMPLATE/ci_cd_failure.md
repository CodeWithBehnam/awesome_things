---
name: CI/CD Workflow Failure
about: Report a failing GitHub Actions workflow
title: '[CI/CD] '
labels: ci-cd, workflow
assignees: ''
---

## Workflow Information

- **Workflow Name**: <!-- e.g., Continuous Integration, Security Scan -->
- **Job Name**: <!-- e.g., Lint and Validate, Security Scan -->
- **Run ID**: <!-- Link to the failed workflow run -->
- **Commit SHA**: <!-- The commit that triggered the failure -->

## Failure Category

<!-- Mark the relevant category with an "x" -->

- [ ] Secret Scanning False Positive
- [ ] Broken Link Detection
- [ ] Markdown Linting Error
- [ ] Shell Script Syntax Error
- [ ] Missing File Error
- [ ] Other (please specify)

## Error Output

```
Paste the error output from the workflow logs here
```

## Known False Positives (if applicable)

<!-- Check if this matches any known issues -->

- [ ] `path-key` package name triggering secret scan
- [ ] Documentation mentioning "password"/"secret" triggering alerts
- [ ] `secrets.GITHUB_TOKEN` in workflow files
- [ ] Triple backticks in shell script
- [ ] Broken external URL (404)
- [ ] Lock file being scanned for secrets

## Expected Fix

<!-- What needs to be done to resolve this? -->

### For Secret Scanning Issues:

- [ ] Add file/directory to exclusion list
- [ ] Add pattern to false positive filter
- [ ] Update secret scanning configuration

### For Link Checking Issues:

- [ ] Update broken URL to working alternative
- [ ] Add URL to ignore patterns
- [ ] Create missing documentation file

### For Shell Script Issues:

- [ ] Fix quote escaping
- [ ] Update grep pattern
- [ ] Add proper error handling

## Proposed Solution

<!-- Optional: Describe how you would fix this -->

```yaml
# If you have a configuration change, paste it here
```

## Related Files

<!-- List files that need to be modified -->

- `.github/workflows/security-scan.yml`
- `.github/workflows/ci.yml`
- `.github/workflows/markdown-link-check.json`
- Other: 

## Additional Context

<!-- Any other relevant information -->

---

**Quick Reference for Common Fixes:**

### Secret Scan Exclusions Template:
```yaml
--exclude-dir=<directory> \
--exclude="<pattern>" \
| grep -v "<false-positive-pattern>"
```

### Link Check Ignore Pattern:
```json
{
  "ignorePatterns": [
    {
      "pattern": "^<url-pattern>"
    }
  ]
}
```

### Shell Script Quote Fix:
```bash
# Use single quotes for literal strings with special chars
if grep -q '```mermaid' README.md; then
```
