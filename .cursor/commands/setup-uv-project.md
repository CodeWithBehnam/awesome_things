# Setup UV Project Command

Initialize a new Python project using UV package manager with best practices and modern development setup.

## Project Setup Process

When I use this command, follow these steps:

1. **Project Initialization**
   - Create new project with `uv init project-name`
   - Set up proper directory structure
   - Initialize Git repository if not exists
   - Pin Python version to latest stable

2. **Dependency Management**
   - Add core dependencies based on project type
   - Add development dependencies (testing, linting, formatting)
   - Create proper pyproject.toml configuration
   - Generate initial lock file

3. **Development Tools Setup**
   - Install essential development tools
   - Configure code formatting and linting
   - Set up testing framework
   - Add pre-commit hooks if requested

4. **Documentation and Configuration**
   - Create comprehensive README.md
   - Add .gitignore for Python projects
   - Configure development environment
   - Provide setup instructions

## Setup Workflow

### 1. Project Initialization
```bash
# Create new project
uv init my-project
cd my-project

# Pin Python version
uv python pin 3.12

# Verify setup
uv run python --version
```

### 2. Core Dependencies
```bash
# Add essential packages based on project type
uv add requests          # HTTP requests
uv add flask            # Web framework (if web project)
uv add sqlalchemy       # Database ORM (if database project)
uv add fastapi          # Modern API framework (if API project)
```

### 3. Development Dependencies
```bash
# Add development tools
uv add --dev pytest     # Testing framework
uv add --dev black      # Code formatter
uv add --dev ruff       # Fast linter
uv add --dev mypy       # Type checker
uv add --dev isort      # Import sorter
uv add --dev pre-commit # Git hooks
```

### 4. Project Configuration
```bash
# Sync all dependencies
uv sync

# Verify installation
uv run python -c "import requests; print('Setup successful!')"
uv run pytest --version
uv run black --version
uv run ruff --version
```

## Project Types and Configurations

### Web Application (Flask/FastAPI)
```bash
# Core dependencies
uv add flask sqlalchemy requests
uv add --dev pytest black ruff mypy

# Additional tools
uv add --dev flask-testing  # Flask testing utilities
uv add --dev gunicorn      # WSGI server
```

### API Project (FastAPI)
```bash
# Core dependencies
uv add fastapi uvicorn sqlalchemy pydantic
uv add --dev pytest black ruff mypy

# Additional tools
uv add --dev httpx         # HTTP client for testing
uv add --dev pytest-asyncio  # Async testing
```

### Data Science Project
```bash
# Core dependencies
uv add pandas numpy matplotlib seaborn jupyter
uv add --dev pytest black ruff mypy

# Additional tools
uv add --dev jupyterlab   # Jupyter Lab
uv add --dev notebook     # Jupyter Notebook
```

### CLI Tool Project
```bash
# Core dependencies
uv add click typer rich
uv add --dev pytest black ruff mypy

# Additional tools
uv add --dev pytest-click  # Click testing utilities
```

## Development Environment Setup

### Code Quality Tools
```bash
# Install and configure tools
uv tool install ruff
uv tool install black
uv tool install mypy

# Create configuration files
echo "[tool.black]" > pyproject.toml
echo "line-length = 88" >> pyproject.toml
echo "target-version = ['py312']" >> pyproject.toml
```

### Testing Setup
```bash
# Configure pytest
echo "[tool.pytest.ini_options]" >> pyproject.toml
echo "testpaths = ['tests']" >> pyproject.toml
echo "python_files = ['test_*.py']" >> pyproject.toml
```

### Pre-commit Hooks
```bash
# Install pre-commit
uv add --dev pre-commit

# Create .pre-commit-config.yaml
cat > .pre-commit-config.yaml << EOF
repos:
  - repo: https://github.com/psf/black
    rev: 23.3.0
    hooks:
      - id: black
  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.0.270
    hooks:
      - id: ruff
        args: [--fix]
  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.3.0
    hooks:
      - id: mypy
EOF

# Install pre-commit hooks
uv run pre-commit install
```

## Documentation Setup

### README.md Template
```markdown
# Project Name

Brief description of the project.

## Prerequisites

- Python 3.12+
- UV package manager

## Installation

```bash
# Clone the repository
git clone <repository-url>
cd project-name

# Install dependencies
uv sync

# Verify installation
uv run python --version
```

## Usage

```bash
# Run the application
uv run python main.py

# Run tests
uv run pytest

# Format code
uv run black .

# Lint code
uv run ruff check .
```

## Development

```bash
# Install development dependencies
uv sync

# Run all quality checks
uv run black .
uv run ruff check .
uv run mypy .
uv run pytest
```
```

### .gitignore Template
```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual environments
.venv/
venv/
ENV/
env/
.env

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# UV specific
uv.lock
```

## Quality Assurance

### Verify Setup
```bash
# Check Python version
uv run python --version

# Check all tools
uv run pytest --version
uv run black --version
uv run ruff --version
uv run mypy --version

# Run initial tests
uv run pytest

# Format code
uv run black .

# Lint code
uv run ruff check .
```

### Test Project Structure
```bash
# Verify project structure
ls -la
# Should show: pyproject.toml, uv.lock, .venv/, src/, tests/

# Check dependencies
uv tree

# Verify lock file
uv lock --check
```

## Best Practices

### Project Organization
- **Use src/ layout** for package organization
- **Separate tests** in tests/ directory
- **Document everything** in README.md
- **Use type hints** throughout codebase

### Dependency Management
- **Pin Python version** for consistency
- **Use version constraints** for dependencies
- **Commit uv.lock** to version control
- **Regularly update** dependencies

### Development Workflow
- **Use `uv run`** for all commands
- **Run quality checks** before committing
- **Use pre-commit hooks** for automation
- **Write tests** for all functionality

## Troubleshooting

### Common Issues
```bash
# If UV not found
curl -LsSf https://astral.sh/uv/install.sh | sh

# If Python version issues
uv python install 3.12
uv python pin 3.12

# If dependency conflicts
uv cache clean
uv sync --reinstall
```

### Verification Commands
```bash
# Check UV installation
uv --version

# Check Python version
uv run python --version

# Check all dependencies
uv tree

# Run all quality checks
uv run black . && uv run ruff check . && uv run mypy . && uv run pytest
```

## Output Requirements

- **Complete project setup** with all dependencies
- **Working development environment** with tools configured
- **Comprehensive documentation** with setup instructions
- **Quality assurance** with all checks passing
- **Ready-to-use project** that follows best practices
