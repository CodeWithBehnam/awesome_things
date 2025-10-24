# GitHub Actions Workflows

This directory contains comprehensive GitHub Actions workflows for the **awesome_things** repository, designed to maintain high-quality documentation and ensure repository health.

## 🚀 **Workflow Overview**

### **Core Workflows**

| Workflow | Purpose | Trigger | Frequency |
|----------|---------|---------|-----------|
| **`ci.yml`** | Main CI pipeline | Push/PR | On every change |
| **`markdown-lint.yml`** | Markdown quality | Push/PR | On documentation changes |
| **`docs-validation.yml`** | Documentation validation | Push/PR | On documentation changes |
| **`security-scan.yml`** | Security scanning | Push/PR/Schedule | Weekly + on changes |
| **`health-check.yml`** | Repository health | Schedule | Weekly |
| **`auto-docs-update.yml`** | Automated updates | Schedule | Weekly |

### **Workflow Details**

#### 🔄 **Continuous Integration (`ci.yml`)**
- **Purpose**: Main CI pipeline that runs all quality checks
- **Triggers**: Push to main/master, Pull requests, Manual dispatch
- **Jobs**:
  - Lint and validate documentation
  - Security scanning with Trivy
  - Repository health checks
  - Comprehensive reporting

#### 📝 **Markdown Linting (`markdown-lint.yml`)**
- **Purpose**: Ensure markdown quality and consistency
- **Features**:
  - Markdownlint with custom configuration
  - Broken link detection
  - Link validation
- **Configuration**: `.markdownlint.json`

#### 📚 **Documentation Validation (`docs-validation.yml`)**
- **Purpose**: Validate documentation completeness and structure
- **Features**:
  - Mermaid diagram validation
  - Documentation structure checks
  - Table of contents validation
  - TODO/FIXME detection

#### 🔒 **Security Scanning (`security-scan.yml`)**
- **Purpose**: Comprehensive security analysis
- **Features**:
  - Trivy vulnerability scanning
  - Secret detection
  - Dependency vulnerability checks
  - GitHub Actions security validation
- **Schedule**: Every Monday at 3 AM UTC

#### 🏥 **Health Check (`health-check.yml`)**
- **Purpose**: Monitor repository health and structure
- **Features**:
  - Repository structure validation
  - Documentation completeness checks
  - Security issue detection
  - Link validation
  - Size analysis
- **Schedule**: Every Sunday at 6 AM UTC

#### 🤖 **Automated Documentation Updates (`auto-docs-update.yml`)**
- **Purpose**: Keep documentation current and accurate
- **Features**:
  - Badge timestamp updates
  - External link validation
  - Version information checks
  - Automated commits
  - Issue creation for manual updates
- **Schedule**: Every Monday at 2 AM UTC

## 📋 **Configuration Files**

### **Markdown Linting Configuration**
- **File**: `.markdownlint.json`
- **Purpose**: Custom markdownlint rules for the repository
- **Features**:
  - Line length limits (100 characters)
  - Ordered list preferences
  - Heading spacing requirements
  - Code block language requirements

### **Link Check Configuration**
- **File**: `.github/workflows/markdown-link-check.json`
- **Purpose**: Configure link checking behavior
- **Features**:
  - Localhost URL ignoring
  - Relative path replacement
  - Custom headers for GitHub
  - Timeout and retry settings

## 🎯 **Workflow Benefits**

### **Quality Assurance**
- ✅ Consistent markdown formatting
- ✅ Valid documentation structure
- ✅ Working internal and external links
- ✅ Proper Mermaid diagram syntax

### **Security**
- ✅ Vulnerability scanning
- ✅ Secret detection
- ✅ Dependency security checks
- ✅ GitHub Actions security validation

### **Maintenance**
- ✅ Automated documentation updates
- ✅ Repository health monitoring
- ✅ Regular security scans
- ✅ Comprehensive reporting

### **Developer Experience**
- ✅ Clear feedback on documentation issues
- ✅ Automated quality checks
- ✅ Security vulnerability alerts
- ✅ Health status reporting

## 🚀 **Getting Started**

### **1. Enable Workflows**
The workflows are automatically enabled when pushed to the repository. No additional setup required.

### **2. Monitor Results**
- Check the **Actions** tab in GitHub for workflow results
- Review any failed checks and address issues
- Download artifacts for detailed reports

### **3. Customize Configuration**
- Modify `.markdownlint.json` for different linting rules
- Update `markdown-link-check.json` for link checking preferences
- Adjust workflow schedules in individual workflow files

### **4. Manual Triggers**
- Use **workflow_dispatch** to manually trigger workflows
- Access via GitHub Actions tab → Select workflow → Run workflow

## 📊 **Monitoring and Reports**

### **Artifacts Generated**
- **CI Report**: Comprehensive CI/CD status
- **Health Report**: Repository health analysis
- **Security Report**: Security scan results

### **Notifications**
- Failed workflows trigger notifications
- Security issues create GitHub issues
- Documentation problems are highlighted in PRs

## 🔧 **Troubleshooting**

### **Common Issues**

#### **Markdown Linting Failures**
```bash
# Run locally to test
npm install -g markdownlint-cli
markdownlint "**/*.md" --config .markdownlint.json
```

#### **Link Check Failures**
- Check if external links are accessible
- Verify internal documentation links
- Update link check configuration if needed

#### **Security Scan Issues**
- Review Trivy scan results
- Address any vulnerability findings
- Update dependencies if needed

### **Workflow Debugging**
- Check workflow logs in GitHub Actions
- Review individual job outputs
- Use workflow_dispatch for manual testing

## 📈 **Best Practices**

### **Documentation**
- Keep markdown files under 100 characters per line
- Use proper heading hierarchy
- Include language tags for code blocks
- Validate Mermaid diagrams

### **Security**
- Regularly review security scan results
- Keep dependencies up to date
- Use pinned action versions
- Implement proper secret management

### **Maintenance**
- Monitor workflow health regularly
- Address failed checks promptly
- Review and update configurations as needed
- Keep documentation current

## 🔗 **Resources**

- **GitHub Actions Documentation**: [https://docs.github.com/en/actions](https://docs.github.com/en/actions)
- **Markdownlint Rules**: [https://github.com/DavidAnson/markdownlint](https://github.com/DavidAnson/markdownlint)
- **Trivy Security Scanner**: [https://github.com/aquasecurity/trivy](https://github.com/aquasecurity/trivy)
- **Mermaid Diagrams**: [https://mermaid.js.org/](https://mermaid.js.org/)

---

**Last Updated**: $(date)
**Repository**: [awesome_things](https://github.com/CodeWithBehnam/awesome_things)
