# GitHub Configuration Documentation

This directory contains all GitHub-specific configuration, workflows, and documentation.

## 📁 Directory Structure

```
.github/
├── ISSUE_TEMPLATE/
│   ├── bug_report.md           # Bug report template
│   ├── ci_cd_failure.md        # CI/CD workflow failure template
│   └── documentation.md        # Documentation update template
├── workflows/
│   ├── ci.yml                  # Continuous Integration workflow
│   ├── security-scan.yml       # Security scanning workflow
│   ├── health-check.yml        # Repository health checks
│   ├── docs-validation.yml     # Documentation validation
│   ├── markdown-lint.yml       # Markdown linting
│   ├── auto-docs-update.yml    # Automatic documentation updates
│   ├── markdown-link-check.json # Link checker configuration
│   └── README.md               # Workflows documentation
├── CONTRIBUTING.md             # Contribution guidelines
├── PULL_REQUEST_TEMPLATE.md   # PR template
├── RULES.md                    # Repository rules and best practices
├── CI_CD_RESOLUTION_SUMMARY.md # Summary of resolved CI/CD issues
└── README.md                   # This file
```

## 📋 Quick Start

### For Contributors

1. **Before starting work:**
   - Read [CONTRIBUTING.md](CONTRIBUTING.md)
   - Review [RULES.md](RULES.md) for critical rules

2. **Before committing:**
   - Run local tests (see CONTRIBUTING.md)
   - Verify no secrets in code
   - Check all links are valid

3. **When creating a PR:**
   - Use the PR template
   - Complete all checklist items
   - Ensure all workflows pass

### For Reviewers

1. **Check PR template completion:**
   - All checklist items marked
   - Tests pass locally
   - Documentation updated

2. **Verify workflows:**
   - ✅ Lint and Validate
   - ✅ Security Scan
   - ✅ Health Check
   - ✅ Generate Report

## 🔧 Workflows

### Main Workflows

| Workflow | Purpose | Triggers |
|----------|---------|----------|
| **CI** | Linting, validation, link checking | Push, PR |
| **Security Scan** | Vulnerability and secret scanning | Push, PR, Schedule |
| **Health Check** | Repository structure validation | Push, PR |
| **Docs Validation** | Documentation completeness check | Push to docs/ |
| **Markdown Lint** | Markdown style checking | Push, PR |

### Workflow Status

All workflows are currently: ✅ **PASSING**

## 📚 Documentation

### Essential Reading

1. **[RULES.md](RULES.md)** - Critical rules and quick fixes
2. **[CONTRIBUTING.md](CONTRIBUTING.md)** - Complete contribution guide
3. **[CI_CD_RESOLUTION_SUMMARY.md](CI_CD_RESOLUTION_SUMMARY.md)** - Issues resolved

### Issue Templates

Use the appropriate template when creating issues:

- **Bug Report** - For general bugs
- **CI/CD Failure** - For workflow failures
- **Documentation** - For doc issues/improvements

## 🚨 Common Issues & Quick Fixes

### 1. Secret Scanning False Positive

**Error:** `path-key` or `secrets.GITHUB_TOKEN` detected

**Fix:** These are already filtered in the workflow. If you see this, the workflow configuration may need updating.

### 2. Broken Link in Documentation

**Error:** 404 on external URL

**Fix:** Check [RULES.md](RULES.md) for list of working URLs to use instead.

### 3. Shell Script Syntax Error

**Error:** `unexpected EOF while looking for matching backtick`

**Fix:** Use single quotes for strings with backticks:

```bash
# Wrong
grep "```code"

# Correct
grep '```code'
```

## 🔐 Security

### Secret Scanning

Our security workflow scans for:

- Hardcoded API keys
- Passwords
- Tokens
- Other sensitive data

**Excluded from scanning:**

- Lock files (`package-lock.json`, etc.)
- Documentation files (`*.md`)
- Configuration files (`*.yml`, `*.json`)
- Cache directories (`.cache`, `.cursor`)

**Known false positives are filtered:**

- `path-key` (npm package)
- `secrets.GITHUB_TOKEN` (correct GitHub Actions syntax)
- Security documentation text

## 📊 Metrics & Monitoring

### Workflow Success Rate

Monitor at: `https://github.com/CodeWithBehnam/awesome_things/actions`

### Expected Run Times

| Workflow | Expected Duration |
|----------|------------------|
| Lint and Validate | ~30-40s |
| Security Scan | ~15-20s |
| Health Check | ~5-10s |
| Generate Report | ~3-5s |

## 🛠️ Maintenance

### Regular Tasks

**Weekly:**

- Review failed workflows
- Check for security alerts

**Monthly:**

- Review and update deprecated URLs
- Audit secret scanning exclusions
- Update issue templates if needed

**Quarterly:**

- Full documentation review
- Link validation across all docs
- Update RULES.md with new patterns

## 🤝 Support

### Need Help?

1. Check [RULES.md](RULES.md) for quick fixes
2. Review [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines
3. Search existing issues
4. Create new issue with appropriate template

### Reporting Issues

- **CI/CD Issues:** Use CI/CD Failure template
- **Documentation Issues:** Use Documentation template
- **Other Issues:** Use Bug Report template

## 📝 Recent Updates

**October 24, 2025:**

- ✅ Fixed all CI/CD workflow failures
- ✅ Enhanced secret scanning configuration
- ✅ Updated all broken documentation links
- ✅ Created comprehensive documentation
- ✅ Added issue templates and PR template

## 🔗 Useful Links

### Internal

- [Contributing Guidelines](CONTRIBUTING.md)
- [Repository Rules](RULES.md)
- [Issue Resolution Summary](CI_CD_RESOLUTION_SUMMARY.md)
- [Workflows Documentation](workflows/README.md)

### External

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Markdown Guide](https://www.markdownguide.org/)
- [Semantic Versioning](https://semver.org/)

---

**Maintained by:** CodeWithBehnam  
**Last Updated:** October 24, 2025  
**Status:** ✅ All systems operational
