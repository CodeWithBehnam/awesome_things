# Setup Docker UV Python Project Command

Automatically initialize and configure a complete Docker + UV Python project with optimized development and production environments.

## Project Setup Process

When I use this command, follow these steps:

1. **Project Analysis**
   - Analyze existing project structure
   - Identify Python version and dependencies
   - Determine project type (web app, API, ML, etc.)
   - Assess development and production requirements

2. **UV Project Initialization**
   - Initialize UV project with proper configuration
   - Set up dependency management
   - Configure Python version and environment
   - Create project structure and files

3. **Docker Configuration**
   - Generate optimized Dockerfile patterns
   - Create Docker Compose configurations
   - Set up development and production environments
   - Configure volume mounts and networking

4. **CI/CD Setup**
   - Create GitHub Actions workflows
   - Set up automated testing and building
   - Configure container registry integration
   - Implement deployment automation

5. **Quality Assurance**
   - Set up testing frameworks
   - Configure linting and formatting
   - Implement security scanning
   - Create documentation and examples

## Project Structure

### 1. Basic Project Layout
```
project/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       └── security.yml
├── .docker/
│   ├── Dockerfile.dev
│   ├── Dockerfile.prod
│   └── docker-compose.yml
├── src/
│   ├── __init__.py
│   ├── main.py
│   └── app/
├── tests/
│   ├── __init__.py
│   ├── test_main.py
│   └── conftest.py
├── docs/
│   ├── README.md
│   ├── API.md
│   └── DEPLOYMENT.md
├── pyproject.toml
├── uv.lock
├── .dockerignore
├── .gitignore
└── README.md
```

### 2. Advanced Project Layout
```
project/
├── .github/
│   └── workflows/
│       ├── ci.yml
│       ├── cd.yml
│       ├── security.yml
│       └── release.yml
├── .docker/
│   ├── Dockerfile.dev
│   ├── Dockerfile.prod
│   ├── Dockerfile.test
│   ├── docker-compose.yml
│   ├── docker-compose.prod.yml
│   └── nginx.conf
├── src/
│   ├── __init__.py
│   ├── main.py
│   ├── app/
│   │   ├── __init__.py
│   │   ├── api/
│   │   ├── core/
│   │   ├── models/
│   │   └── services/
│   └── tests/
│       ├── __init__.py
│       ├── test_main.py
│       ├── test_api.py
│       └── conftest.py
├── docs/
│   ├── README.md
│   ├── API.md
│   ├── DEPLOYMENT.md
│   └── DEVELOPMENT.md
├── scripts/
│   ├── setup.sh
│   ├── deploy.sh
│   └── test.sh
├── pyproject.toml
├── uv.lock
├── .dockerignore
├── .gitignore
├── .env.example
└── README.md
```

## UV Project Configuration

### 1. pyproject.toml
```toml
[project]
name = "my-project"
version = "0.1.0"
description = "A Python project with Docker and UV"
authors = [
    {name = "Your Name", email = "your.email@example.com"}
]
readme = "README.md"
requires-python = ">=3.12"
dependencies = [
    "fastapi>=0.104.0",
    "uvicorn[standard]>=0.24.0",
    "pydantic>=2.5.0",
    "python-multipart>=0.0.6",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "black>=23.0.0",
    "isort>=5.12.0",
    "mypy>=1.7.0",
    "ruff>=0.1.0",
]
test = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "pytest-asyncio>=0.21.0",
    "httpx>=0.25.0",
]
security = [
    "safety>=2.3.0",
    "bandit>=1.7.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=7.4.0",
    "pytest-cov>=4.1.0",
    "black>=23.0.0",
    "isort>=5.12.0",
    "mypy>=1.7.0",
    "ruff>=0.1.0",
]

[tool.black]
line-length = 88
target-version = ['py312']

[tool.isort]
profile = "black"
multi_line_output = 3

[tool.mypy]
python_version = "3.12"
warn_return_any = true
warn_unused_configs = true
disallow_untyped_defs = true

[tool.ruff]
line-length = 88
target-version = "py312"

[tool.pytest.ini_options]
testpaths = ["tests"]
python_files = ["test_*.py"]
python_classes = ["Test*"]
python_functions = ["test_*"]
addopts = "--cov=src --cov-report=term-missing --cov-report=html"
```

### 2. Environment Configuration
```bash
# .env.example
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Redis
REDIS_URL=redis://localhost:6379

# Application
DEBUG=true
LOG_LEVEL=info
SECRET_KEY=your-secret-key-here

# Docker
DOCKER_REGISTRY=ghcr.io
DOCKER_IMAGE=your-username/your-project
```

## Docker Configuration

### 1. Development Dockerfile
```dockerfile
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

WORKDIR /app

# Set environment variables
ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen

# Copy source code
COPY . .

# Expose development port
EXPOSE 8000

# Run development server
CMD ["uv", "run", "python", "-m", "uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]
```

### 2. Production Dockerfile
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

# Run production server
CMD ["python", "-m", "gunicorn", "--bind", "0.0.0.0:8000", "--workers", "4", "--worker-class", "uvicorn.workers.UvicornWorker", "src.main:app"]
```

### 3. Docker Compose Configuration
```yaml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: .docker/Dockerfile.dev
    ports:
      - "8000:8000"
    volumes:
      - .:/app
      - /app/.venv  # Exclude venv from volume mount
    environment:
      - PYTHONPATH=/app
      - UV_SYSTEM_PYTHON=1
      - DATABASE_URL=postgresql://myapp:myapp@postgres:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - postgres
      - redis
    command: uv run python -m uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload

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

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

## CI/CD Configuration

### 1. GitHub Actions CI
```yaml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
          
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

      - name: Run linting
        run: |
          uv run python -m black --check src/
          uv run python -m isort --check-only src/
          uv run python -m mypy src/
          uv run python -m ruff check src/

      - name: Run tests
        run: uv run python -m pytest tests/ --cov=src --cov-report=xml
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db

      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          file: ./coverage.xml

  security:
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

      - name: Run security audit
        run: |
          uv run python -m safety check
          uv run python -m bandit -r src/
```

### 2. GitHub Actions CD
```yaml
name: CD

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  build:
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

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ghcr.io/${{ github.repository }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=semver,pattern={{major}}.{{minor}}
            type=sha

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: .docker/Dockerfile.prod
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - name: Deploy to production
        run: |
          echo "Deploying to production..."
          # Add your deployment commands here
```

## Development Workflow

### 1. Local Development
```bash
# Start development environment
docker-compose up -d

# Run tests
docker-compose exec app uv run python -m pytest tests/

# Run linting
docker-compose exec app uv run python -m black src/
docker-compose exec app uv run python -m isort src/
docker-compose exec app uv run python -m mypy src/

# Run security audit
docker-compose exec app uv run python -m safety check
docker-compose exec app uv run python -m bandit -r src/
```

### 2. Production Deployment
```bash
# Build production image
docker build -f .docker/Dockerfile.prod -t myapp:latest .

# Run production container
docker run -d \
  --name myapp \
  -p 8000:8000 \
  -e DATABASE_URL=postgresql://user:pass@host:5432/db \
  -e REDIS_URL=redis://host:6379 \
  myapp:latest

# Check container status
docker ps
docker logs myapp
```

## Quality Assurance

### 1. Testing Framework
```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from src.main import app

@pytest.fixture
def client():
    return TestClient(app)

@pytest.fixture
def test_db():
    # Set up test database
    pass
```

### 2. Test Examples
```python
# tests/test_main.py
import pytest
from fastapi.testclient import TestClient

def test_health_check(client: TestClient):
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "healthy"}

def test_root_endpoint(client: TestClient):
    response = client.get("/")
    assert response.status_code == 200
```

### 3. Security Testing
```python
# tests/test_security.py
import pytest
from fastapi.testclient import TestClient

def test_sql_injection_protection(client: TestClient):
    # Test SQL injection protection
    pass

def test_authentication_required(client: TestClient):
    # Test authentication requirements
    pass
```

## Documentation

### 1. README.md
```markdown
# My Project

A Python project with Docker and UV package manager.

## Development

### Prerequisites
- Docker and Docker Compose
- UV Python package manager

### Setup
```bash
# Clone the repository
git clone <repository-url>
cd my-project

# Start development environment
docker-compose up -d

# Install dependencies
docker-compose exec app uv sync
```

### Running Tests
```bash
# Run all tests
docker-compose exec app uv run python -m pytest tests/

# Run with coverage
docker-compose exec app uv run python -m pytest tests/ --cov=src
```

### Production Deployment
```bash
# Build production image
docker build -f .docker/Dockerfile.prod -t myapp:latest .

# Run production container
docker run -d --name myapp -p 8000:8000 myapp:latest
```

## API Documentation

API documentation should be created in `docs/API.md` with detailed endpoint specifications.

## Deployment

Deployment instructions should be documented in `docs/DEPLOYMENT.md` for production setup.
```

### 2. API Documentation
```markdown
# API Documentation

## Endpoints

### Health Check
- **GET** `/health`
- Returns application health status

### Root
- **GET** `/`
- Returns welcome message

## Authentication

All endpoints require authentication unless specified otherwise.

## Error Handling

The API returns standard HTTP status codes and JSON error responses.
```

## Output Requirements

- Complete project structure with all necessary files
- Optimized Dockerfile patterns for development and production
- Docker Compose configurations for local development
- CI/CD pipeline setup with GitHub Actions
- Testing framework with comprehensive test coverage
- Security scanning and audit tools
- Documentation and examples
- Development and deployment scripts
- Quality assurance and compliance setup

## Success Criteria

- **Project Structure**: Well-organized and scalable
- **Docker Configuration**: Optimized for performance and security
- **CI/CD Pipeline**: Automated testing, building, and deployment
- **Testing Coverage**: Comprehensive test suite with security testing
- **Documentation**: Clear and complete documentation
- **Development Experience**: Easy setup and development workflow
- **Production Ready**: Secure and scalable production deployment
- **Quality Standards**: Meet industry best practices and compliance
