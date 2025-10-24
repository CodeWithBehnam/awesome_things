---
applyTo: "**/*.py,**/pyproject.toml,**/uv.lock,**/requirements*.txt"
---

# Python Development with UV Guidelines

## UV Package Manager Standards

### Default to UV for All Python Operations

- **Always use UV commands** instead of pip, poetry, or conda
- **Never use pip directly** - use `uv add` instead of `pip install`
- **Use UV's built-in environment management** - avoid manual venv activation
- **Leverage UV's speed** - 10-100x faster than traditional package managers
- **Use UV's Python version management** - built-in Python installation and management

### Core UV Commands

```bash
# Package Management
uv add package-name              # Install package
uv remove package-name           # Remove package
uv sync                         # Sync dependencies from lockfile
uv lock                         # Generate/update lockfile

# Environment Management
uv venv                         # Create virtual environment
uv run python script.py         # Run script with dependencies
uv run pytest                   # Run tests
uv run black .                  # Format code

# Python Version Management
uv python install 3.12          # Install Python version
uv python pin 3.12              # Pin project to Python version
uv python list                  # List available Python versions
```

## Project Structure Standards

### pyproject.toml Configuration

```toml
[project]
name = "project-name"
version = "0.1.0"
description = "Project description"
requires-python = ">=3.8"
dependencies = [
    "requests>=2.25.0",
    "flask>=2.0.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=6.0.0",
    "black>=22.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=6.0.0",
    "black>=22.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]
```

### File Organisation

```
project/
├── pyproject.toml              # Project configuration
├── uv.lock                     # Lock file (auto-generated)
├── .venv/                      # Virtual environment
├── src/
│   └── project_name/
│       ├── __init__.py
│       └── main.py
├── tests/
│   └── test_main.py
└── docs/
    └── README.md
```

## Development Workflow

### Initial Project Setup

```bash
# Create new project
uv init project-name
cd project-name

# Pin Python version
uv python pin 3.12

# Add core dependencies
uv add requests flask sqlalchemy

# Add development dependencies
uv add --dev pytest black ruff mypy

# Sync all dependencies
uv sync
```

### Daily Development Workflow

```bash
# Sync dependencies (always start with this)
uv sync

# Run application
uv run python src/project_name/main.py

# Run tests
uv run pytest

# Format code
uv run black .

# Lint code
uv run ruff check .

# Type checking
uv run mypy src/
```

### Adding New Dependencies

```bash
# Add production dependency
uv add fastapi

# Add development dependency
uv add --dev pytest-cov

# Add with version constraint
uv add "requests>=2.25.0"

# Add multiple packages
uv add requests flask sqlalchemy
```

## Code Quality Standards

### Type Safety

```python
# Always use type hints
from typing import List, Dict, Optional, Union

def process_data(data: List[Dict[str, str]]) -> Optional[str]:
    """Process data with proper type annotations."""
    if not data:
        return None
    
    # Implementation here
    return "processed"
```

### Error Handling

```python
# Use custom exception classes
class ProjectError(Exception):
    """Base exception for project-specific errors."""
    pass

class ValidationError(ProjectError):
    """Raised when data validation fails."""
    pass

# Implement proper error handling
def validate_input(data: Dict[str, str]) -> bool:
    """Validate input data."""
    try:
        if not data.get("required_field"):
            raise ValidationError("Required field is missing")
        return True
    except ValidationError as e:
        logger.error(f"Validation failed: {e}")
        return False
```

### Testing Standards

```python
# Use pytest with proper fixtures
import pytest
from unittest.mock import Mock, patch

@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {"key": "value", "number": 42}

def test_process_data(sample_data):
    """Test data processing functionality."""
    result = process_data([sample_data])
    assert result is not None
    assert isinstance(result, str)

@patch('requests.get')
def test_api_call(mock_get):
    """Test API calls with mocking."""
    mock_get.return_value.json.return_value = {"status": "success"}
    
    response = make_api_call("https://api.example.com")
    assert response["status"] == "success"
```

## Performance Optimisation

### UV-Specific Optimisations

```bash
# Use UV's global cache
uv cache clean                    # Clear cache if needed
uv sync --reinstall              # Reinstall with fresh cache

# Leverage UV's speed
uv add package-name              # Much faster than pip install
uv run python script.py          # Faster than manual activation
```

### Code Performance

```python
# Use appropriate data structures
from collections import defaultdict, Counter
from typing import Dict, List

# Efficient data processing
def process_large_dataset(data: List[Dict]) -> Dict[str, int]:
    """Process large datasets efficiently."""
    counter = Counter()
    for item in data:
        counter[item.get("category", "unknown")] += 1
    return dict(counter)

# Use generators for memory efficiency
def read_large_file(filename: str):
    """Read large files without loading everything into memory."""
    with open(filename, 'r') as file:
        for line in file:
            yield line.strip()
```

## Security Best Practices

### Dependency Security

```bash
# Regular security checks
uv run safety check              # Check for known vulnerabilities
uv run bandit -r src/            # Security linting

# Keep dependencies updated
uv sync --upgrade                # Update all dependencies
uv add --upgrade package-name    # Update specific package
```

### Code Security

```python
# Secure input handling
import secrets
import hashlib

def generate_secure_token(length: int = 32) -> str:
    """Generate cryptographically secure token."""
    return secrets.token_urlsafe(length)

def hash_password(password: str) -> str:
    """Hash password securely."""
    salt = secrets.token_hex(16)
    return hashlib.pbkdf2_hmac('sha256', password.encode(), salt.encode(), 100000).hex()
```

## Docker Integration

### UV in Docker

```dockerfile
# Use UV's Python image
FROM ghcr.io/astral-sh/uv:python3.12-bookworm-slim

# Set UV environment variables
ENV UV_LINK_MODE=copy
ENV UV_COMPILE_BYTECODE=1
ENV UV_PYTHON_DOWNLOADS=never

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Copy application code
COPY . .

# Run application
CMD ["uv", "run", "python", "-m", "your_app"]
```

## Common Patterns

### Application Structure

```python
# main.py
from typing import Optional
import logging
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Application:
    """Main application class."""
    
    def __init__(self, config_path: Optional[Path] = None):
        """Initialize application."""
        self.config_path = config_path or Path("config.yaml")
        self.logger = logger
    
    def run(self) -> None:
        """Run the application."""
        self.logger.info("Starting application")
        # Application logic here
        self.logger.info("Application completed")

if __name__ == "__main__":
    app = Application()
    app.run()
```

### Configuration Management

```python
# config.py
from typing import Dict, Any
import yaml
from pathlib import Path

class Config:
    """Application configuration."""
    
    def __init__(self, config_path: Path):
        """Load configuration from file."""
        self.config_path = config_path
        self._config = self._load_config()
    
    def _load_config(self) -> Dict[str, Any]:
        """Load configuration from YAML file."""
        try:
            with open(self.config_path, 'r') as file:
                return yaml.safe_load(file)
        except FileNotFoundError:
            return self._default_config()
    
    def _default_config(self) -> Dict[str, Any]:
        """Return default configuration."""
        return {
            "database": {"url": "sqlite:///app.db"},
            "api": {"port": 8000, "host": "0.0.0.0"},
            "logging": {"level": "INFO"}
        }
    
    def get(self, key: str, default: Any = None) -> Any:
        """Get configuration value."""
        return self._config.get(key, default)
```

## Testing Strategies

### Unit Testing

```python
# tests/test_main.py
import pytest
from unittest.mock import Mock, patch
from src.main import Application

class TestApplication:
    """Test application functionality."""
    
    def test_initialization(self):
        """Test application initialization."""
        app = Application()
        assert app is not None
    
    @patch('src.main.logging.getLogger')
    def test_logging_setup(self, mock_logger):
        """Test logging configuration."""
        app = Application()
        mock_logger.assert_called_once()
    
    def test_run_method(self):
        """Test application run method."""
        app = Application()
        # Should not raise any exceptions
        app.run()
```

### Integration Testing

```python
# tests/test_integration.py
import pytest
import requests
from src.main import Application

class TestIntegration:
    """Integration tests."""
    
    @pytest.fixture
    def app(self):
        """Create application instance for testing."""
        return Application()
    
    def test_api_endpoint(self, app):
        """Test API endpoint functionality."""
        # Start application in test mode
        # Make API calls
        # Verify responses
        pass
```

## Troubleshooting

### Common UV Issues

1. **Dependency Conflicts**
   ```bash
   # Clear cache and reinstall
   uv cache clean
   uv sync --reinstall
   ```

2. **Python Version Issues**
   ```bash
   # List available Python versions
   uv python list
   
   # Install specific version
   uv python install 3.12
   
   # Pin project to version
   uv python pin 3.12
   ```

3. **Permission Issues**
   ```bash
   # Check UV installation
   uv --version
   
   # Reinstall if needed
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

### Performance Issues

1. **Slow Dependency Resolution**
   ```bash
   # Use UV's global cache
   uv sync
   
   # Check dependency tree
   uv tree
   ```

2. **Large Lock Files**
   ```bash
   # Update lock file
   uv lock
   
   # Check for unnecessary dependencies
   uv tree --depth 1
   ```

## Best Practices Summary

### Development Workflow
- Always use `uv sync` to start development
- Use `uv run` for all Python commands
- Never manually activate virtual environments
- Use `uv add` instead of `pip install`

### Code Quality
- Use type hints for all functions
- Implement proper error handling
- Write comprehensive tests
- Use UV's built-in tools for formatting and linting

### Performance
- Leverage UV's speed advantages
- Use appropriate data structures
- Implement efficient algorithms
- Monitor memory usage

### Security
- Regular dependency updates
- Security scanning with safety and bandit
- Secure input handling
- Proper authentication and authorisation

---

*These instructions ensure Python development follows modern best practices with UV package manager, focusing on speed, security, and maintainability.*
