---
applyTo: "**/Dockerfile*,**/docker-compose*.yml,**/docker-compose*.yaml"
---

# Docker Configuration Guidelines

## Dockerfile Standards

### Base Image Selection

- **UV Integration**: Use `ghcr.io/astral-sh/uv:python3.12-bookworm-slim` for Python projects
- **Multi-Stage Builds**: Separate build and runtime stages for optimal image size
- **Security**: Use minimal base images and distroless final images when possible
- **Performance**: Leverage UV's 10-100x faster dependency resolution

### Environment Variables

Always include these critical UV environment variables:

```dockerfile
ENV UV_LINK_MODE=copy              # Required for Docker filesystems
ENV UV_COMPILE_BYTECODE=1          # Faster startup times
ENV UV_PYTHON_DOWNLOADS=never      # Use system Python
ENV UV_PYTHON=python3.12           # Specify Python version
ENV UV_PROJECT_ENVIRONMENT=/app    # Project environment path
ENV UV_CACHE_DIR=/tmp/uv-cache     # Cache directory
```

### Multi-Stage Build Pattern

```dockerfile
# Stage 1: Builder
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim AS builder

ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock ./

# Install dependencies with cache mount
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

# Create non-root user for security
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
    CMD ["python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health', timeout=5)"]

EXPOSE 8000

CMD ["python", "-m", "your_app"]
```

## Security Best Practices

### Non-Root User
```dockerfile
# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser
```

### Minimal Base Images
```dockerfile
# Use distroless for maximum security
FROM gcr.io/distroless/python3-debian11
```

### Security Scanning
```dockerfile
# Add security scanning stage
FROM builder AS security
RUN uv add safety bandit
RUN uv run safety check
RUN uv run bandit -r src/
```

## Performance Optimisation

### Layer Caching
```dockerfile
# Copy dependency files first (changes less frequently)
COPY pyproject.toml uv.lock ./

# Install dependencies (cached if files don't change)
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev

# Copy application code last (changes most frequently)
COPY . .
```

### Build Cache
```dockerfile
# Use BuildKit cache mounts
RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen --no-dev
```

### Bytecode Compilation
```dockerfile
# Enable bytecode compilation for faster startup
ENV UV_COMPILE_BYTECODE=1
```

## Docker Compose Standards

### Development Environment
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

## Common Patterns

### Development Dockerfile
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

### Production Dockerfile
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

## Troubleshooting

### Common Issues

1. **UV_LINK_MODE Error**
   ```dockerfile
   # Solution: Set UV_LINK_MODE=copy
   ENV UV_LINK_MODE=copy
   ```

2. **Python Download Issues**
   ```dockerfile
   # Solution: Disable Python downloads
   ENV UV_PYTHON_DOWNLOADS=never
   ```

3. **Cache Issues**
   ```dockerfile
   # Solution: Use BuildKit cache mounts
   RUN --mount=type=cache,target=/root/.cache/uv \
       uv sync --frozen --no-dev
   ```

4. **Permission Issues**
   ```dockerfile
   # Solution: Use non-root user
   RUN useradd -m appuser && chown -R appuser:appuser /app
   USER appuser
   ```

### Debugging

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

## Quality Standards

### Build Optimisation
- Use multi-stage builds for smaller images
- Implement proper layer caching
- Use BuildKit cache mounts
- Optimise dependency installation order

### Security Implementation
- Use non-root users
- Implement minimal base images
- Add security scanning stages
- Use distroless images when possible

### Performance Considerations
- Enable bytecode compilation
- Use proper caching strategies
- Optimise layer sizes
- Implement health checks

---

*These instructions ensure Docker configurations follow modern best practices with UV integration, security, and performance optimisation.*
