# UV Development Workflow Command

Execute comprehensive development workflows using UV Python package manager for efficient Python development.

## Development Workflow Process

When I use this command, follow these steps:

1. **Environment Setup**
   - Verify UV installation and Python version
   - Sync project dependencies
   - Check development tools availability
   - Ensure clean development environment

2. **Code Quality Checks**
   - Run code formatting with Black
   - Execute linting with Ruff
   - Perform type checking with MyPy
   - Run import sorting with isort

3. **Testing Workflow**
   - Execute test suite with pytest
   - Generate coverage reports
   - Run specific test categories
   - Validate test results

4. **Development Tasks**
   - Add new dependencies as needed
   - Update existing dependencies
   - Run development tools
   - Execute project-specific commands

## Standard Development Workflow

### Daily Development Session
```bash
# Start development session
uv sync                    # Sync dependencies
uv run python main.py     # Run application
uv run pytest            # Run tests
uv run black .            # Format code
uv run ruff check .       # Lint code
uv run mypy .             # Type checking
```

### Code Quality Workflow
```bash
# Complete code quality check
uv run black .            # Format code
uv run isort .            # Sort imports
uv run ruff check .       # Lint code
uv run ruff check --fix . # Auto-fix linting issues
uv run mypy .             # Type checking
uv run pytest            # Run tests
```

### Testing Workflow
```bash
# Run all tests
uv run pytest

# Run specific test file
uv run pytest tests/test_main.py

# Run tests with coverage
uv run pytest --cov=src

# Run tests with verbose output
uv run pytest -v

# Run tests in parallel
uv run pytest -n auto
```

## Dependency Management Workflow

### Adding New Dependencies
```bash
# Add production dependency
uv add requests

# Add with version constraint
uv add "requests>=2.25.0"

# Add development dependency
uv add --dev pytest-cov

# Add multiple dependencies
uv add flask sqlalchemy redis

# Add from requirements file
uv pip install -r requirements.txt
```

### Updating Dependencies
```bash
# Update all dependencies
uv sync --upgrade

# Update specific dependency
uv add "requests>=2.26.0"

# Check for outdated packages
uv tree --outdated

# Update lock file
uv lock
```

### Removing Dependencies
```bash
# Remove production dependency
uv remove requests

# Remove development dependency
uv remove --dev pytest-cov

# Remove multiple dependencies
uv remove flask sqlalchemy
```

## Project-Specific Workflows

### Web Application Development
```bash
# Start web server
uv run python app.py

# Run database migrations
uv run flask db upgrade

# Run web tests
uv run pytest tests/web/

# Start development server
uv run flask run --debug
```

### API Development
```bash
# Start API server
uv run uvicorn main:app --reload

# Run API tests
uv run pytest tests/api/

# Generate API documentation
uv run python -m fastapi docs

# Test API endpoints
uv run pytest tests/test_api.py -v
```

### Data Science Workflow
```bash
# Start Jupyter Lab
uv run jupyter lab

# Run data analysis
uv run python analysis.py

# Run data tests
uv run pytest tests/data/

# Generate reports
uv run python generate_report.py
```

### CLI Tool Development
```bash
# Test CLI tool
uv run python cli.py --help

# Run CLI tests
uv run pytest tests/cli/

# Install CLI tool
uv pip install -e .

# Test CLI functionality
uv run python cli.py command --option value
```

## Development Tools Workflow

### Code Formatting
```bash
# Format all Python files
uv run black .

# Check formatting without changes
uv run black --check .

# Format specific file
uv run black src/main.py

# Format with custom configuration
uv run black --line-length 100 .
```

### Linting and Code Analysis
```bash
# Run Ruff linter
uv run ruff check .

# Auto-fix linting issues
uv run ruff check --fix .

# Check specific rules
uv run ruff check --select E,W .

# Generate linting report
uv run ruff check --output-format json .
```

### Type Checking
```bash
# Run MyPy type checking
uv run mypy .

# Check specific module
uv run mypy src/main.py

# Run with strict mode
uv run mypy --strict .

# Generate type checking report
uv run mypy --html-report mypy-report .
```

### Import Management
```bash
# Sort imports
uv run isort .

# Check import sorting
uv run isort --check-only .

# Sort with custom configuration
uv run isort --profile black .
```

## Testing Workflows

### Unit Testing
```bash
# Run all unit tests
uv run pytest tests/unit/

# Run tests with coverage
uv run pytest --cov=src tests/

# Run specific test class
uv run pytest tests/test_models.py::TestUser

# Run tests matching pattern
uv run pytest -k "test_user"
```

### Integration Testing
```bash
# Run integration tests
uv run pytest tests/integration/

# Run with database
uv run pytest tests/integration/ --with-db

# Run API integration tests
uv run pytest tests/api_integration/
```

### Performance Testing
```bash
# Run performance tests
uv run pytest tests/performance/

# Run with profiling
uv run pytest --profile tests/performance/

# Run load tests
uv run python tests/load_test.py
```

## Build and Deployment Workflow

### Building Project
```bash
# Build distribution packages
uv build

# Build wheel and source distribution
uv build --wheel --sdist

# Check build
uv run twine check dist/*
```

### Publishing
```bash
# Publish to PyPI
uv publish

# Publish to test PyPI
uv publish --repository testpypi

# Publish to private registry
uv publish --index-url https://your-registry.com/simple/
```

## Environment Management

### Python Version Management
```bash
# Install specific Python version
uv python install 3.12

# List available Python versions
uv python list

# Pin project to Python version
uv python pin 3.12

# Find installed Python versions
uv python find
```

### Virtual Environment Management
```bash
# Create virtual environment
uv venv

# Create with specific Python version
uv venv --python 3.12

# Activate environment (manual)
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows

# Use UV's built-in activation
uv run python script.py
```

### Cache Management
```bash
# Clean UV cache
uv cache clean

# Show cache information
uv cache info

# Clear specific cache
uv cache clean --package requests
```

## Debugging and Troubleshooting

### Dependency Issues
```bash
# Check dependency tree
uv tree

# Check for conflicts
uv tree --duplicates

# Resolve conflicts
uv sync --reinstall

# Check lock file
uv lock --check
```

### Environment Issues
```bash
# Verify Python version
uv run python --version

# Check installed packages
uv pip list

# Verify virtual environment
uv run python -c "import sys; print(sys.prefix)"
```

### Performance Issues
```bash
# Check installation speed
time uv sync

# Profile dependency resolution
uv sync --verbose

# Check cache usage
uv cache info
```

## Quality Assurance Workflow

### Pre-commit Checks
```bash
# Run all quality checks
uv run black . && uv run ruff check . && uv run mypy . && uv run pytest

# Run with pre-commit
uv run pre-commit run --all-files

# Install pre-commit hooks
uv run pre-commit install
```

### Continuous Integration
```bash
# CI workflow commands
uv sync
uv run black --check .
uv run ruff check .
uv run mypy .
uv run pytest --cov=src
uv build
```

## Advanced Workflows

### Workspace Management
```bash
# Create workspace
uv init --workspace my-workspace

# Add workspace members
uv init --package backend
uv init --package frontend

# Sync workspace
uv sync --workspace
```

### Custom Index Management
```bash
# Add custom index
uv add --index-url https://your-registry.com/simple/ package

# Use multiple indexes
uv add --extra-index-url https://pypi.org/simple/ package
```

### Tool Management
```bash
# Install global tools
uv tool install ruff
uv tool install black

# Run tools
uv tool run ruff check .
uv tool run black .

# List installed tools
uv tool list
```

## Best Practices

### Daily Workflow
1. **Start with `uv sync`** to ensure dependencies are up-to-date
2. **Use `uv run`** for all commands to ensure proper environment
3. **Run quality checks** before committing code
4. **Use version constraints** for dependencies
5. **Commit uv.lock** to version control

### Performance Optimization
1. **Keep dependencies minimal** to reduce resolution time
2. **Use lock files** for reproducible builds
3. **Leverage UV's global cache** for faster installs
4. **Use parallel execution** where possible

### Team Collaboration
1. **Use consistent Python versions** across team
2. **Share uv.lock** file for reproducible environments
3. **Document setup process** in README
4. **Use same development tools** for consistency

## Output Requirements

- **Execute all commands** using UV package manager
- **Ensure proper environment** activation
- **Run quality checks** for code standards
- **Verify test results** and coverage
- **Maintain dependency consistency** across team
- **Follow UV best practices** for all operations
