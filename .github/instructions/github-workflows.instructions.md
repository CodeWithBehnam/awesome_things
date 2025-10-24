---
applyTo: ".github/workflows/**/*.yml,.github/workflows/**/*.yaml"
---

# GitHub Actions Workflow Guidelines

## Workflow Structure

### Standard Workflow Template

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.12'

      - name: Install UV
        run: curl -LsSf https://astral.sh/uv/install.sh | sh

      - name: Add UV to PATH
        run: echo "$HOME/.cargo/bin" >> $GITHUB_PATH

      - name: Install dependencies
        run: uv sync

      - name: Run tests
        run: uv run python -m pytest tests/ --cov=src

      - name: Run linting
        run: |
          uv run python -m black --check src/
          uv run python -m isort --check-only src/
          uv run python -m mypy src/

  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    
    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ghcr.io/${{ github.repository }}:latest
            ghcr.io/${{ github.repository }}:${{ github.sha }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    
    steps:
      - name: Deploy to production
        run: |
          # Add your deployment commands here
          echo "Deploying to production..."
```

## UV Integration Standards

### Python Setup with UV

```yaml
- name: Set up Python
  uses: actions/setup-python@v4
  with:
    python-version: '3.12'

- name: Install UV
  run: curl -LsSf https://astral.sh/uv/install.sh | sh

- name: Add UV to PATH
  run: echo "$HOME/.cargo/bin" >> $GITHUB_PATH

- name: Install dependencies
  run: uv sync

- name: Run tests
  run: uv run python -m pytest tests/ --cov=src
```

### UV with Docker

```yaml
- name: Build Docker image with UV
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: |
      ghcr.io/${{ github.repository }}:latest
      ghcr.io/${{ github.repository }}:${{ github.sha }}
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

## Docker Integration

### Multi-Stage Build with UV

```yaml
- name: Set up Docker Buildx
  uses: docker/setup-buildx-action@v3

- name: Login to Container Registry
  uses: docker/login-action@v3
  with:
    registry: ghcr.io
    username: ${{ github.actor }}
    password: ${{ secrets.GITHUB_TOKEN }}

- name: Build and push Docker image
  uses: docker/build-push-action@v5
  with:
    context: .
    push: true
    tags: |
      ghcr.io/${{ github.repository }}:latest
      ghcr.io/${{ github.repository }}:${{ github.sha }}
    cache-from: type=gha
    cache-to: type=gha,mode=max
```

### Docker Security Scanning

```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'ghcr.io/${{ github.repository }}:${{ github.sha }}'
    format: 'sarif'
    output: 'trivy-results.sarif'

- name: Upload Trivy scan results to GitHub Security tab
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: 'trivy-results.sarif'
```

## Testing Standards

### Comprehensive Testing

```yaml
- name: Run tests
  run: uv run python -m pytest tests/ --cov=src --cov-report=xml

- name: Run linting
  run: |
    uv run python -m black --check src/
    uv run python -m isort --check-only src/
    uv run python -m mypy src/
    uv run python -m flake8 src/

- name: Run security checks
  run: |
    uv run python -m safety check
    uv run python -m bandit -r src/
```

### Test Coverage

```yaml
- name: Upload coverage reports
  uses: codecov/codecov-action@v3
  with:
    file: ./coverage.xml
    flags: unittests
    name: codecov-umbrella
```

## Security Best Practices

### Secret Management

```yaml
- name: Deploy to production
  env:
    DATABASE_URL: ${{ secrets.DATABASE_URL }}
    API_KEY: ${{ secrets.API_KEY }}
  run: |
    # Deployment commands
    echo "Deploying to production..."
```

### Dependency Scanning

```yaml
- name: Run dependency scan
  run: |
    uv run python -m safety check
    uv run python -m pip-audit
```

### Code Quality

```yaml
- name: Run code quality checks
  run: |
    uv run python -m black --check src/
    uv run python -m isort --check-only src/
    uv run python -m mypy src/
    uv run python -m flake8 src/
```

## Performance Optimisation

### Caching Strategies

```yaml
- name: Cache UV dependencies
  uses: actions/cache@v3
  with:
    path: ~/.cache/uv
    key: ${{ runner.os }}-uv-${{ hashFiles('**/uv.lock') }}
    restore-keys: |
      ${{ runner.os }}-uv-

- name: Cache Docker layers
  uses: actions/cache@v3
  with:
    path: /tmp/.buildx-cache
    key: ${{ runner.os }}-buildx-${{ github.sha }}
    restore-keys: |
      ${{ runner.os }}-buildx-
```

### Parallel Jobs

```yaml
strategy:
  matrix:
    python-version: ['3.11', '3.12']
    os: [ubuntu-latest, windows-latest, macos-latest]
```

## Deployment Patterns

### Staging Deployment

```yaml
deploy-staging:
  needs: test
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/develop'
  
  steps:
    - name: Deploy to staging
      run: |
        echo "Deploying to staging environment..."
```

### Production Deployment

```yaml
deploy-production:
  needs: [test, build]
  runs-on: ubuntu-latest
  if: github.ref == 'refs/heads/main'
  
  steps:
    - name: Deploy to production
      run: |
        echo "Deploying to production environment..."
```

## Quality Gates

### Required Checks

```yaml
- name: Check test coverage
  run: |
    coverage run -m pytest tests/
    coverage report --fail-under=80

- name: Check code quality
  run: |
    uv run python -m black --check src/
    uv run python -m isort --check-only src/
    uv run python -m mypy src/
```

### Security Gates

```yaml
- name: Security scan
  run: |
    uv run python -m safety check
    uv run python -m bandit -r src/
```

## Environment-Specific Configurations

### Development Environment

```yaml
- name: Set up development environment
  run: |
    uv sync --dev
    uv run python -m pytest tests/ --cov=src
```

### Production Environment

```yaml
- name: Set up production environment
  run: |
    uv sync --no-dev
    uv run python -m pytest tests/ --cov=src
```

## Monitoring and Alerting

### Health Checks

```yaml
- name: Health check
  run: |
    curl -f http://localhost:8000/health || exit 1
```

### Performance Monitoring

```yaml
- name: Performance test
  run: |
    uv run python -m pytest tests/performance/ --benchmark-only
```

## Best Practices

### Workflow Organisation

- Use descriptive job names
- Implement proper dependencies between jobs
- Use conditional execution for different branches
- Include proper error handling and notifications

### Security Implementation

- Use secrets for sensitive information
- Implement proper access controls
- Include security scanning in all workflows
- Use minimal permissions for actions

### Performance Optimisation

- Use caching for dependencies and build artifacts
- Implement parallel job execution where possible
- Use appropriate runner types for different tasks
- Optimise build times with proper layer caching

---

*These instructions ensure GitHub Actions workflows follow modern best practices with UV integration, security, and performance optimisation.*
