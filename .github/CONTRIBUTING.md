# Contributing Guidelines

## Code Quality Standards

### Documentation

#### Markdown Files

- All markdown files must pass markdownlint validation
- Links must be valid and not return 404 errors
- Use triple backticks with single quotes in shell scripts: `'```'` not "```"
- Always include proper code fence language identifiers

#### Link Management

- **Never** link to non-existent files
- Before adding links to documentation files, ensure the target file exists
- Use relative paths for internal documentation
- Verify external links are working before committing

#### Known Valid URL Patterns

- ✅ Astral UV: `https://docs.astral.sh/uv/`
- ✅ GitHub Actions: `https://docs.github.com/en/actions/`
- ✅ VS Code Copilot: `https://code.visualstudio.com/docs/editor/github-copilot`

#### Deprecated URLs to Avoid

- ❌ `https://docs.astral.sh/uv/best-practices/` (Use: `https://docs.astral.sh/uv/`)
- ❌ `https://docs.astral.sh/uv/guides/production/` (Use: `https://docs.astral.sh/uv/guides/integration/docker/`)
- ❌ `https://docs.astral.sh/guides/*` (Use: `https://docs.astral.sh/uv/concepts/*` or `https://docs.astral.sh/uv/guides/*`)
- ❌ `https://github.com/actions/cheat-sheet` (Use: `https://github.com/actions/starter-workflows`)
- ❌ `https://code.visualstudio.com/docs/copilot` (Use: `https://code.visualstudio.com/docs/editor/github-copilot`)

### GitHub Actions Workflows

#### Shell Script Best Practices
1. **Quote Handling in Shell Scripts**
   - Use single quotes for literal strings containing special characters
   - Use double quotes for strings needing variable expansion
   - Example (correct): `if grep -q '```mermaid' README.md; then`
   - Example (wrong): `if grep -q "```mermaid" README.md; then`

2. **Secret Scanning Configuration**
   - Always exclude lock files: `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, etc.
   - Always exclude cache directories: `.cache`, `node_modules`, `.cursor`
   - Always exclude documentation files when scanning for secrets: `*.md`, `*.mdc`
   - Use `--binary-files=without-match` to skip binary files
   - Filter known false positives: `path-key`, `secrets.GITHUB_TOKEN`, etc.

3. **Required Exclusions for Secret Scanning**
   ```yaml
   --exclude-dir=.git \
   --exclude-dir=.github \
   --exclude-dir=node_modules \
   --exclude-dir=.cache \
   --exclude-dir=.cursor \
   --exclude-dir=vendor \
   --exclude-dir=dist \
   --exclude-dir=build \
   --exclude="*.md" \
   --exclude="*.mdc" \
   --exclude="*.yml" \
   --exclude="*.yaml" \
   --exclude="*.json" \
   --exclude="*.lock" \
   --exclude="package-lock.json" \
   --binary-files=without-match
   ```

4. **False Positive Filtering**
   Always filter these patterns from secret scan results:
   - `path-key` (npm package name)
   - `secrets.GITHUB_TOKEN` (proper GitHub Actions secret reference)
   - `Never commit sensitive` (documentation text)
   - `Implement proper secrets` (documentation text)

### File Structure Requirements

#### Required Files
- `LICENSE` - Must exist at repository root (referenced in README.md)
- `.markdownlint.json` - Markdown linting configuration
- `.github/workflows/markdown-link-check.json` - Link checking configuration

#### Documentation Structure
```
docs/
├── cursor-folder-guide.md
├── docker-uv-guide.md
├── github-actions-cicd-guide.md
├── github-copilot-guide.md
├── global.md
└── uv-python-guide.md
```

### Commit Standards

#### Pre-Commit Checklist
- [ ] All markdown files pass linting
- [ ] All links are valid and accessible
- [ ] No hardcoded secrets in source code
- [ ] Shell scripts use proper quote escaping
- [ ] Lock files are excluded from secret scanning
- [ ] Documentation files don't trigger false positive secret alerts

#### What NOT to Commit
- ❌ Hardcoded API keys, passwords, or tokens
- ❌ Links to non-existent documentation files
- ❌ Broken or deprecated external URLs
- ❌ Shell scripts with unescaped backticks in grep patterns
- ❌ Configuration that scans lock files for secrets

#### What IS Safe to Commit
- ✅ `${{ secrets.GITHUB_TOKEN }}` in workflow files
- ✅ Documentation mentioning "password" or "secret" as examples
- ✅ Package names containing "key" (e.g., "path-key")
- ✅ Security best practice documentation
- ✅ Cursor rules mentioning security practices

### Testing Before Push

Run these commands locally before pushing:

```bash
# Test markdown linting
npx markdownlint "**/*.md" --config .markdownlint.json

# Test for hardcoded secrets (excluding false positives)
grep -r -E "(password|secret|key|token|api_key)" . \
  --exclude-dir=.git \
  --exclude-dir=node_modules \
  --exclude-dir=.cache \
  --exclude-dir=.cursor \
  --exclude="*.md" \
  --exclude="*.json" \
  --exclude="*.lock" \
  --binary-files=without-match 2>/dev/null | \
  grep -v "path-key" | \
  grep -v "secrets.GITHUB_TOKEN" | \
  grep -v "Never commit sensitive" | \
  grep -v "Implement proper secrets"

# Check for broken links (if you have markdown-link-check installed)
find . -name "*.md" -not -path "./node_modules/*" | \
  xargs -I {} markdown-link-check {} --config .github/workflows/markdown-link-check.json
```

## CI/CD Pipeline

### Workflow Jobs
1. **Lint and Validate** - Markdown linting and link checking
2. **Security Scan** - Trivy scanning and secret detection
3. **Health Check** - Repository structure validation
4. **Generate Report** - Comprehensive CI/CD report

### Expected Workflow Behavior
- All jobs should pass on valid commits
- Secret scanning should not fail on:
  - Package lock files
  - Documentation files
  - Cursor rules
  - Proper GitHub Actions secret references
- Link checking should not fail on:
  - Localhost URLs
  - Cursor command references that don't exist yet

## Common Issues and Solutions

### Issue: "unexpected EOF while looking for matching ``'"
**Solution**: Use single quotes around triple backticks in shell scripts
```bash
# Wrong
if grep -q "```mermaid" file.md; then

# Correct
if grep -q '```mermaid' file.md; then
```

### Issue: "Potential secrets found" - path-key
**Solution**: Package names are not secrets. Ensure lock files are excluded:
```yaml
--exclude="package-lock.json" \
--exclude="*.lock"
```

### Issue: "404 Not Found" on documentation links
**Solution**: Always verify external URLs before committing. Use current documentation:
- Check official documentation site structure
- Test links manually
- Use wayback machine for moved content

### Issue: Binary file matches in secret scanning
**Solution**: Add `--binary-files=without-match` to grep command

### Issue: Cursor rules triggering secret alerts
**Solution**: Exclude `.cursor` directory and `.mdc` files

## Version Control Best Practices

### Branch Protection
Ensure these checks pass before merging:
- ✅ All CI workflows pass
- ✅ No unresolved review comments
- ✅ Up to date with base branch

### Pull Request Requirements
- Descriptive title and description
- Link to related issues
- All workflow checks passing
- No new security vulnerabilities introduced

## Questions?

If you encounter issues not covered here:
1. Check existing GitHub Actions workflow logs
2. Review recent commits that passed CI
3. Consult the `.github/workflows/` directory for configuration
4. Open an issue with detailed error messages

## Useful Commands

```bash
# Install markdown linting
npm install -g markdownlint-cli

# Lint all markdown files
markdownlint "**/*.md"

# Check for secrets manually
grep -rn "password\|secret\|key\|token" --include="*.py" --include="*.js" --include="*.ts" .

# Validate YAML files
yamllint .github/workflows/*.yml
```

---

**Remember**: Prevention is better than fixing in CI! Always test locally before pushing.
