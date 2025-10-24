# Docker UV Python Workflow Command

Automatically create, optimize, and manage Docker containers with UV Python package manager for development and production environments.

## Workflow Process

When I use this command, follow these steps:

1. **Analysis Phase**
   - Analyze project structure and requirements
   - Identify Python version and dependencies
   - Determine development vs production needs
   - Assess security and performance requirements

2. **Dockerfile Generation**
   - Create optimized multi-stage Dockerfile
   - Implement proper layer caching
   - Set critical environment variables
   - Include security best practices

3. **Docker Compose Setup**
   - Generate development environment configuration
   - Create production environment setup
   - Configure service dependencies
   - Set up volume mounts and networking

4. **CI/CD Integration**
   - Create GitHub Actions workflow
   - Set up automated testing and building
   - Configure container registry integration
   - Implement deployment automation

5. **Quality Assurance**
   - Validate Dockerfile syntax and structure
   - Test build process and image size
   - Verify security configurations
   - Ensure performance optimization

## Dockerfile Patterns

### 1. Production Multi-Stage Build
```dockerfile
# Stage 1: Builder
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy application code
COPY . .

# Stage 2: Runtime
FROM python:3.12-slim-bookworm

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health', timeout=5)"]

EXPOSE 8000

# Run the application
CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "main:app"]
```

### 2. Development Environment
```dockerfile
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Install development dependencies
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

# Copy source code
COPY . .

# Expose development port
EXPOSE 8000

# Run development server
CMD ["uv", "run", "python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

### 3. Testing and Security Scanning
```dockerfile
# Stage 1: Dependencies
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS deps

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install all dependencies (including dev)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen

# Stage 2: Testing
FROM deps AS test

# Copy source code
COPY . .

# Run tests
RUN uv run python -m pytest tests/ --cov=src --cov-report=term-missing
RUN uv run python -m black --check src/
RUN uv run python -m isort --check-only src/
RUN uv run python -m mypy src/

# Stage 3: Security scanning
FROM test AS security

# Install security tools
RUN uv add safety bandit

# Run security checks
RUN uv run safety check
RUN uv run bandit -r src/ -f json -o bandit-report.json

# Stage 4: Production build
FROM deps AS production

# Copy source code
COPY . .

# Install production dependencies only
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Stage 5: Final runtime
FROM python:3.12-slim-bookworm

# Copy virtual environment
COPY --from=production /app/.venv /app/.venv
COPY --from=production /app /app

# Set environment
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "main:app"]
```

## Docker Compose Configurations

### 1. Development Environment
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/.venv  # Exclude venv from volume mount
    environment:
      - PYTHONPATH=/app
      - UV_SYSTEM_PYTHON=1
    command: uv run python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: myapp
      POSTGRES_PASSWORD: myapp
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### 2. Production Environment
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://myapp:myapp@postgres:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    restart: unless-stopped

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - app

  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: myapp
      POSTGRES_PASSWORD: myapp
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    restart: unless-stopped

volumes:
  postgres_data:
```

## CI/CD Integration

### 1. GitHub Actions Workflow
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

### 2. GitLab CI Pipeline
```yaml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

test:
  stage: test
  image: python:3.12-slim
  before_script:
    - curl -LsSf https://astral.sh/uv/install.sh | sh
    - export PATH="$HOME/.cargo/bin:$PATH"
  script:
    - uv sync
    - uv run python -m pytest tests/ --cov=src
    - uv run python -m black --check src/
    - uv run python -m isort --check-only src/
    - uv run python -m mypy src/

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  only:
    - main

deploy:
  stage: deploy
  script:
    - echo "Deploying to production..."
  only:
    - main
```

## Best Practices Implementation

### 1. Performance Optimization
- Use multi-stage builds for smaller images
- Implement proper layer caching
- Enable bytecode compilation
- Use BuildKit cache mounts

### 2. Security Hardening
- Create non-root users
- Use minimal base images
- Implement security scanning
- Follow OWASP guidelines

### 3. Development Workflow
- Hot reload for development
- Volume mounts for code changes
- Separate dev/prod configurations
- Integrated testing and linting

### 4. Production Deployment
- Health checks and monitoring
- Proper logging and error handling
- Resource limits and scaling
- Backup and recovery procedures

## Troubleshooting Guide

### 1. Common Issues
- **UV_LINK_MODE Error**: Set `UV_LINK_MODE=copy`
- **Python Download Issues**: Set `UV_PYTHON_DOWNLOADS=never`
- **Cache Issues**: Use BuildKit cache mounts
- **Permission Issues**: Use non-root users

### 2. Debugging Commands
```bash
# Build with debug output
docker build --progress=plain --no-cache -t myapp .

# Run with debug shell
docker run -it --entrypoint /bin/bash myapp

# Check environment variables
docker run --rm myapp env

# Check Python path
docker run --rm myapp python -c "import sys; print(sys.path)"
```

### 3. Performance Monitoring
```bash
# Check image size
docker images myapp

# Monitor resource usage
docker stats myapp

# Check build time
time docker build -t myapp .
```

## Advanced Use Cases

### 1. Microservices Architecture
- Service-specific Dockerfiles
- Inter-service communication
- Load balancing and scaling
- Service discovery

### 2. Machine Learning Applications
- ML library optimization
- GPU support configuration
- Model serving and inference
- Data pipeline integration

### 3. Web Applications
- Static asset handling
- CDN integration
- SSL/TLS configuration
- Performance optimization

## Quality Standards

### 1. Code Quality
- Consistent Dockerfile structure
- Proper error handling
- Health checks for production
- Documentation completeness

### 2. Security Standards
- Non-root user implementation
- Vulnerability scanning
- Minimal attack surface
- Secrets management

### 3. Performance Standards
- Build times under 5 minutes
- Image sizes under 500MB
- Startup times under 30 seconds
- Memory usage optimization

### 4. Compliance Requirements
- OWASP container security
- Industry best practices
- Regulatory compliance
- Audit trail maintenance

## Output Requirements

- Generate optimized Dockerfile patterns
- Create Docker Compose configurations
- Set up CI/CD pipeline integration
- Implement security best practices
- Provide troubleshooting guides
- Include performance optimization
- Ensure compliance with standards
- Document all configurations

## Success Criteria

- **Build Performance**: 3-4x faster than traditional methods
- **Image Size**: 30-50% smaller than pip-based images
- **Security**: Non-root users and minimal attack surface
- **Reliability**: Consistent builds and deployments
- **Maintainability**: Clear documentation and examples
- **Scalability**: Support for multiple environments
- **Compliance**: Meet industry standards and best practices
