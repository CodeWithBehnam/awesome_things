# GitHub Actions Secrets Management Guide

## Overview

This guide provides comprehensive best practices for managing secrets in GitHub Actions workflows, ensuring security whilst maintaining functionality.

## Secrets Management Flow

```mermaid
flowchart TD
    A[Developer] --> B[GitHub Repository]
    B --> C[Repository Settings]
    C --> D[Secrets and Variables]
    D --> E[Add Secret]
    E --> F[Encrypted Storage]
    
    G[GitHub Actions Workflow] --> H[Reference Secret]
    H --> I[${{ secrets.SECRET_NAME }}]
    I --> J[Decrypted at Runtime]
    J --> K[Available to Workflow]
    
    L[Environment] --> M[Environment Secrets]
    M --> N[Environment-Specific Access]
    
    O[Organization] --> P[Organization Secrets]
    P --> Q[Cross-Repository Access]
    
    F --> R[Workflow Execution]
    N --> R
    Q --> R
    R --> S[Secure Deployment]
```

## Table of Contents

1. [Understanding GitHub Secrets](#understanding-github-secrets)
2. [Best Practices](#best-practices)
3. [Common Patterns](#common-patterns)
4. [Security Considerations](#security-considerations)
5. [Troubleshooting](#troubleshooting)

## Understanding GitHub Secrets

### What are GitHub Secrets?

GitHub Secrets are encrypted environment variables that can be used in workflows without exposing sensitive information in logs or repository history.

### Types of Secrets

1. **Repository Secrets**: Available to all workflows in a specific repository
2. **Environment Secrets**: Available to workflows in specific environments
3. **Organization Secrets**: Available to all repositories in an organization

### Built-in Secrets

GitHub provides several built-in secrets:

- `GITHUB_TOKEN`: Automatically provided for repository access
- `GITHUB_ACTOR`: The username of the user who triggered the workflow
- `GITHUB_REPOSITORY`: The repository name
- `GITHUB_REF`: The branch or tag ref that triggered the workflow

## Best Practices

### 1. Never Hardcode Secrets

```yaml
# ❌ NEVER DO THIS
env:
  API_KEY: "sk-1234567890abcdef"
  DATABASE_PASSWORD: "mypassword123"

# ✅ CORRECT APPROACH
env:
  API_KEY: ${{ secrets.API_KEY }}
  DATABASE_PASSWORD: ${{ secrets.DATABASE_PASSWORD }}
```

### 2. Use Environment-Specific Secrets

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production  # Uses environment-specific secrets
    steps:
      - name: Deploy
        run: deploy.sh
        env:
          API_URL: ${{ secrets.PROD_API_URL }}
          API_KEY: ${{ secrets.PROD_API_KEY }}
```

### 3. Implement Proper Permissions

```yaml
# Set minimal required permissions
permissions:
  contents: read
  packages: write
  security-events: write
  id-token: write  # Required for OIDC
```

### 4. Use OIDC for Cloud Provider Authentication

```yaml
jobs:
  deploy:
    runs-on: ubuntu-latest
    permissions:
      id-token: write
      contents: read
    steps:
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1
          # No need for access keys with OIDC
```

## Common Patterns

### 1. Docker Registry Authentication

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

- name: Login to GitHub Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}
```

### 2. Database Connections

```yaml
- name: Run database migrations
  run: |
    python manage.py migrate
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    DATABASE_SSL_MODE: require
```

### 3. API Key Management

```yaml
- name: Deploy to external service
  run: |
    curl -H "Authorization: Bearer $API_KEY" \
         -H "Content-Type: application/json" \
         -d '{"version": "${{ github.sha }}"}' \
         https://api.example.com/deploy
  env:
    API_KEY: ${{ secrets.DEPLOYMENT_API_KEY }}
```

### 4. Multi-Environment Deployment

```yaml
strategy:
  matrix:
    environment: [staging, production]
    
jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: ${{ matrix.environment }}
    steps:
      - name: Deploy
        run: deploy.sh
        env:
          API_URL: ${{ secrets.API_URL }}
          API_KEY: ${{ secrets.API_KEY }}
```

## Security Considerations

### 1. Secret Masking

GitHub automatically masks secrets in logs:

```yaml
- name: Use secret
  run: |
    echo "Using API key: ${{ secrets.API_KEY }}"
    # The actual secret value will be masked as ***
```

### 2. Conditional Secret Usage

```yaml
- name: Deploy only on main branch
  if: github.ref == 'refs/heads/main'
  run: deploy.sh
  env:
    DEPLOY_TOKEN: ${{ secrets.DEPLOY_TOKEN }}
```

### 3. Secret Rotation

Implement regular secret rotation:

```yaml
- name: Rotate secrets
  run: |
    # Rotate API keys
    curl -X POST \
      -H "Authorization: Bearer ${{ secrets.ADMIN_TOKEN }}" \
      https://api.example.com/rotate-keys
```

### 4. Audit and Monitoring

```yaml
- name: Log deployment
  run: |
    echo "Deployment initiated by: ${{ github.actor }}"
    echo "Repository: ${{ github.repository }}"
    echo "Ref: ${{ github.ref }}"
    # Log to external monitoring system
    curl -X POST \
      -H "Authorization: Bearer ${{ secrets.MONITORING_TOKEN }}" \
      -d '{"event": "deployment", "actor": "${{ github.actor }}"}' \
      https://monitoring.example.com/events
```

## Advanced Patterns

### 1. Secret Injection via External Systems

```yaml
- name: Get secrets from HashiCorp Vault
  uses: hashicorp/vault-action@v2.5.0
  with:
    url: ${{ secrets.VAULT_URL }}
    token: ${{ secrets.VAULT_TOKEN }}
    secrets: |
      secret/data/ci/aws accessKey | AWS_ACCESS_KEY_ID ;
      secret/data/ci/aws secretKey | AWS_SECRET_ACCESS_KEY
```

### 2. Dynamic Secret Generation

```yaml
- name: Generate temporary credentials
  id: generate-creds
  run: |
    # Generate temporary AWS credentials
    aws sts assume-role \
      --role-arn ${{ secrets.AWS_ROLE_ARN }} \
      --role-session-name github-actions \
      --duration-seconds 3600 > credentials.json
    
    echo "access_key=$(jq -r '.Credentials.AccessKeyId' credentials.json)" >> $GITHUB_OUTPUT
    echo "secret_key=$(jq -r '.Credentials.SecretAccessKey' credentials.json)" >> $GITHUB_OUTPUT
    echo "session_token=$(jq -r '.Credentials.SessionToken' credentials.json)" >> $GITHUB_OUTPUT

- name: Use temporary credentials
  run: aws s3 ls
  env:
    AWS_ACCESS_KEY_ID: ${{ steps.generate-creds.outputs.access_key }}
    AWS_SECRET_ACCESS_KEY: ${{ steps.generate-creds.outputs.secret_key }}
    AWS_SESSION_TOKEN: ${{ steps.generate-creds.outputs.session_token }}
```

### 3. Secret Validation

```yaml
- name: Validate secrets
  run: |
    # Check if required secrets are set
    if [ -z "${{ secrets.API_KEY }}" ]; then
      echo "Error: API_KEY secret is not set"
      exit 1
    fi
    
    # Validate secret format
    if [[ ! "${{ secrets.API_KEY }}" =~ ^sk-[a-zA-Z0-9]{32}$ ]]; then
      echo "Error: API_KEY format is invalid"
      exit 1
    fi
```

## Troubleshooting

### Common Issues

1. **Secret not found**: Ensure the secret is properly configured in repository settings
2. **Permission denied**: Check if the secret is available in the current environment
3. **Masking issues**: Secrets are automatically masked in logs

### Debugging Tips

```yaml
- name: Debug secret availability
  run: |
    # Check if secret exists (without revealing value)
    if [ -n "${{ secrets.API_KEY }}" ]; then
      echo "API_KEY is set (length: ${#API_KEY})"
    else
      echo "API_KEY is not set"
    fi
```

### Security Checklist

- [ ] No hardcoded secrets in workflow files
- [ ] All secrets stored in GitHub Secrets
- [ ] Minimal permissions set
- [ ] Environment-specific secrets used where appropriate
- [ ] OIDC used for cloud provider authentication
- [ ] Secret rotation implemented
- [ ] Audit logging enabled

## Conclusion

Proper secrets management in GitHub Actions is crucial for maintaining security whilst enabling automated workflows. Follow these best practices to ensure your workflows are both secure and functional.

Remember:
- Never commit secrets to version control
- Use environment-specific secrets
- Implement proper permissions
- Consider using OIDC for cloud authentication
- Regularly rotate secrets
- Monitor and audit secret usage
