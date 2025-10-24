# Docker + UV Python: Complete Guide to Containerization

## Overview

Combining Docker with UV Python package manager creates a powerful, fast, and efficient containerization solution for Python applications. UV's 10-100x speed improvements over traditional package managers, combined with Docker's containerization benefits, results in significantly faster builds, smaller images, and more reliable deployments.

**Key Benefits:**

- 🚀 **10-100x faster** dependency resolution and installation
- 📦 **Smaller Docker images** with multi-stage builds
- 🔒 **Enhanced security** with distroless and minimal base images
- ⚡ **Faster CI/CD pipelines** with improved caching
- 🛠️ **Better reproducibility** with lock files and deterministic builds
- 💾 **Optimized layer caching** for faster subsequent builds

## Prerequisites

- Basic understanding of Docker and containerization
- Familiarity with Python development and package management
- UV Python package manager installed locally (for development)
- Docker installed and running on your system

## Installation and Setup

### Install UV Locally

**macOS and Linux:**

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows:**

```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**Verify Installation:**

```bash
uv --version
```

### Docker Setup

**Install Docker:**

- **macOS**: Download Docker Desktop from [docker.com](https://docker.com)
- **Linux**: Follow [Docker installation guide](https://docs.docker.com/engine/install/)
- **Windows**: Download Docker Desktop from [docker.com](https://docker.com)

**Verify Docker Installation:**

```bash
docker --version
docker-compose --version
```

## Core Concepts

### 1. UV Docker Images

UV provides both distroless and derived Docker images:

**Distroless Images (Binary Only):**

- `ghcr.io/astral-sh/uv:latest`
- `ghcr.io/astral-sh/uv:0.9.5` (specific version)
- `ghcr.io/astral-sh/uv:0.8` (latest patch version)

**Derived Images (OS + UV):**

- **Alpine-based**: `ghcr.io/astral-sh/uv:alpine`, `ghcr.io/astral-sh/uv:alpine3.22`
- **Debian-based**: `ghcr.io/astral-sh/uv:debian-slim`, `ghcr.io/astral-sh/uv:bookworm-slim`
- **Python-based**: `ghcr.io/astral-sh/uv:python3.12-bookworm-slim`

### 2. Multi-Stage Build Pattern

The recommended approach uses multi-stage builds:

1. **Builder Stage** - Install dependencies and build application
2. **Runtime Stage** - Copy only necessary artifacts to minimal final image

### 3. Critical Environment Variables

UV requires specific environment variables in Docker:

```dockerfile
ENV UV_LINK_MODE=copy              # Required for Docker filesystems
ENV UV_COMPILE_BYTECODE=1          # Faster startup times
ENV UV_PYTHON_DOWNLOADS=never      # Use system Python
ENV UV_PYTHON=python3.12           # Specify Python version
ENV UV_PROJECT_ENVIRONMENT=/app    # Project environment path
ENV UV_CACHE_DIR=/tmp/uv-cache     # Cache directory
```

## Basic Dockerfile Patterns

### Pattern 1: Simple Single-Stage Build

**Use Case:** Development and simple applications

```dockerfile
# Use UV's Python image directly
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

# Run the application
CMD ["uv", "run", "python", "-m", "your_app"]
```

### Pattern 2: Multi-Stage Build (Recommended)

**Use Case:** Production applications with optimized images

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

# Set environment variables
ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Copy application code
COPY --from=builder /app /app

WORKDIR /app

# Run the application
CMD ["python", "-m", "your_app"]
```

### Pattern 3: Distroless Final Image

**Use Case:** Maximum security and minimal attack surface

```dockerfile
# Stage 1: Builder
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy and install dependencies
COPY pyproject.toml uv.lock ./
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy and build application
COPY . .
RUN uv sync --frozen --no-dev

# Stage 2: Distroless runtime
FROM gcr.io/distroless/python3-debian11

# Copy virtual environment
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

# Set environment
ENV PATH="/app/.venv/bin:$PATH"

# Run as non-root user
USER 65532:65532

# Run the application
CMD ["python", "-m", "your_app"]
```

## Advanced Dockerfile Patterns

### Pattern 4: Development and Production Separation

**Development Dockerfile:**

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

**Production Dockerfile:**

```dockerfile
# Builder stage
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install production dependencies only
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy application code
COPY . .

# Runtime stage
FROM python:3.12-slim-bookworm

# Copy virtual environment
COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

# Set environment
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

# Run production server
CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "main:app"]
```

### Pattern 5: Testing and Security Scanning

**Comprehensive Dockerfile with Testing:**

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

## Docker Compose Integration

### Development Environment

**docker-compose.yml:**

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

### Production Environment

**docker-compose.prod.yml:**

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

### GitHub Actions Workflow

**.github/workflows/ci.yml:**

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

### GitLab CI Pipeline

**.gitlab-ci.yml:**

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

## Best Practices

### 1. Dockerfile Optimization

**Layer Caching:**

```dockerfile
# Copy dependency files first (changes less frequently)
COPY pyproject.toml uv.lock ./

# Install dependencies (cached if files don't change)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy application code last (changes most frequently)
COPY . .
```

**Multi-Architecture Builds:**

```dockerfile
# Use buildx for multi-arch builds
FROM --platform=$BUILDPLATFORM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder
```

### 2. Security Best Practices

**Non-Root User:**

```dockerfile
# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
```

**Minimal Base Images:**

```dockerfile
# Use distroless for maximum security
FROM gcr.io/distroless/python3-debian11
```

**Security Scanning:**

```dockerfile
# Add security scanning stage
FROM builder AS security
RUN uv add safety bandit
RUN uv run safety check
RUN uv run bandit -r src/
```

### 3. Performance Optimization

**Build Cache:**

```dockerfile
# Use BuildKit cache mounts
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev
```

**Bytecode Compilation:**

```dockerfile
# Enable bytecode compilation for faster startup
ENV UV_COMPILE_BYTECODE=1
```

**Multi-Stage Builds:**

```dockerfile
# Separate build and runtime stages
FROM builder AS production
# Copy only necessary artifacts
```

### 4. Development Workflow

**Hot Reload:**

```dockerfile
# Development with hot reload
CMD ["uv", "run", "python", "-m", "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

**Volume Mounts:**

```yaml
# docker-compose.yml
volumes:
  - .:/app
  - /app/.venv  # Exclude venv from volume mount
```

## Troubleshooting

### Common Issues

**1. UV_LINK_MODE Error:**

```dockerfile
# Solution: Set UV_LINK_MODE=copy
ENV UV_LINK_MODE=copy
```

**2. Python Download Issues:**

```dockerfile
# Solution: Disable Python downloads
ENV UV_PYTHON_DOWNLOADS=never
```

**3. Cache Issues:**

```dockerfile
# Solution: Use BuildKit cache mounts
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev
```

**4. Permission Issues:**

```dockerfile
# Solution: Use non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
```

### Debugging

**Build Debugging:**

```bash
# Build with debug output
docker build --progress=plain --no-cache -t myapp .

# Run with debug shell
docker run -it --entrypoint /bin/bash myapp
```

**Runtime Debugging:**

```bash
# Check environment variables
docker run --rm myapp env

# Check Python path
docker run --rm myapp python -c "import sys; print(sys.path)"
```

## Advanced Use Cases

### 1. Microservices Architecture

**Service Dockerfile:**

```dockerfile
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

# Copy service code
COPY src/ ./src/

# Runtime stage
FROM python:3.12-slim-bookworm

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

WORKDIR /app

USER 65532:65532

CMD ["python", "-m", "src.service"]
```

### 2. Machine Learning Applications

**ML Dockerfile:**

```dockerfile
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies including ML libraries
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy application code
COPY . .

# Runtime stage with ML libraries
FROM python:3.12-slim-bookworm

# Install system dependencies for ML
RUN apt-get update && apt-get install -y \
    libgomp1 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

WORKDIR /app

USER 65532:65532

CMD ["python", "-m", "src.ml_service"]
```

### 3. Web Applications with Static Assets

**Web App Dockerfile:**

```dockerfile
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

# Build static assets
RUN uv run python -m build

# Runtime stage
FROM python:3.12-slim-bookworm

COPY --from=builder /app/.venv /app/.venv
COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"
ENV PYTHONUNBUFFERED=1

WORKDIR /app

USER 65532:65532

EXPOSE 8000

CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "main:app"]
```

## Performance Comparison

### Build Time Comparison

| Package Manager | Build Time | Image Size | Cache Efficiency |
|----------------|------------|------------|------------------|
| pip | 12+ minutes | 1.2GB | Poor |
| Poetry | 8+ minutes | 900MB | Fair |
| UV | 3-4 minutes | 600MB | Excellent |

### Memory Usage

| Package Manager | Memory Usage | CPU Usage | Startup Time |
|----------------|--------------|-----------|--------------|
| pip | High | High | Slow |
| Poetry | Medium | Medium | Medium |
| UV | Low | Low | Fast |

## Resources

### Official Documentation

- **UV Documentation**: [https://docs.astral.sh/uv/](https://docs.astral.sh/uv/)
- **UV Docker Guide**: [https://docs.astral.sh/uv/guides/integration/docker/](https://docs.astral.sh/uv/guides/integration/docker/)
- **Docker Documentation**: [https://docs.docker.com/](https://docs.docker.com/)

### Community Resources

- **UV Docker Example**: [https://github.com/astral-sh/uv-docker-example](https://github.com/astral-sh/uv-docker-example)
- **UV GitHub Repository**: [https://github.com/astral-sh/uv](https://github.com/astral-sh/uv)
- **Docker Hub UV Images**: [https://hub.docker.com/r/astral/uv](https://hub.docker.com/r/astral/uv)

### Learning Resources

- **UV Best Practices**: [https://docs.astral.sh/uv/best-practices/](https://docs.astral.sh/uv/best-practices/)
- **Docker Best Practices**: [https://docs.docker.com/develop/dev-best-practices/](https://docs.docker.com/develop/dev-best-practices/)
- **Python in Production**: [https://docs.astral.sh/uv/guides/production/](https://docs.astral.sh/uv/guides/production/)

## Conclusion

Combining Docker with UV Python package manager creates a powerful, efficient, and modern containerization solution. The key benefits include:

**Performance Gains:**

- 10-100x faster dependency resolution
- 3-4x faster build times
- Improved layer caching efficiency
- Smaller final images

**Development Experience:**

- Faster local development
- Better reproducibility
- Simplified dependency management
- Enhanced security

**Production Benefits:**

- Faster deployments
- Reduced resource usage
- Better scalability
- Improved reliability

By following the patterns and best practices outlined in this guide, you can create efficient, secure, and maintainable Docker containers that leverage UV's speed and reliability for optimal Python application deployment.

**Key Takeaways:**

- Use multi-stage builds for optimal image size
- Set proper environment variables for Docker compatibility
- Leverage BuildKit cache mounts for faster builds
- Implement security best practices with non-root users
- Use distroless images for maximum security
- Integrate with CI/CD pipelines for automated deployments

Start using Docker + UV today to experience faster, more reliable Python containerization!
