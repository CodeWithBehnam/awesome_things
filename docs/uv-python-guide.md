# UV Python Package Manager: Complete Guide

## Overview

UV is a modern, high-performance Python package manager and installer written in Rust. It serves as a drop-in replacement for traditional Python package management tools like `pip`, offering significant improvements in speed, reliability, and dependency resolution.

**Key Benefits:**
- 🚀 **10-100x faster** than traditional package managers
- 🗂️ **Comprehensive project management** with universal lockfile
- ❇️ **Script execution** with inline dependency metadata
- 🐍 **Python version management** built-in
- 🛠️ **Tool installation** and management
- 💾 **Disk-space efficient** with global cache
- 🏢 **Workspace support** for scalable projects

## Prerequisites

- Basic familiarity with Python development
- Command line/terminal access
- Internet connection for package downloads

## Installation

### Quick Installation

**macOS and Linux:**
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

**Windows:**
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### Alternative Installation Methods

**Using pip:**
```bash
pip install uv
```

**Using pipx:**
```bash
pipx install uv
```

**Using Homebrew (macOS):**
```bash
brew install uv
```

**Using Scoop (Windows):**
```bash
scoop install uv
```

### Verify Installation

```bash
uv --version
```

## Core Features

### 1. Python Version Management

UV can install and manage Python versions automatically:

```bash
# Install a specific Python version
uv python install 3.12

# List available Python versions
uv python list

# Find installed Python versions
uv python find

# Pin project to specific Python version
uv python pin 3.12

# Uninstall a Python version
uv python uninstall 3.11
```

### 2. Virtual Environment Management

```bash
# Create virtual environment
uv venv

# Create with specific Python version
uv venv --python 3.12

# Activate environment (manual)
source .venv/bin/activate  # Linux/macOS
.venv\Scripts\activate     # Windows

# Or use UV's built-in activation
uv run python script.py
```

### 3. Package Management

#### Installing Packages

```bash
# Install a package
uv add requests

# Install with version constraint
uv add "requests>=2.25.0"

# Install development dependencies
uv add --dev pytest ruff mypy

# Install multiple packages
uv add requests flask sqlalchemy

# Install from requirements.txt
uv pip install -r requirements.txt
```

#### Managing Dependencies

```bash
# Remove a package
uv remove requests

# Sync dependencies from lockfile
uv sync

# Update dependencies
uv sync --upgrade

# Show dependency tree
uv tree

# Lock dependencies
uv lock
```

### 4. Project Management

#### Creating New Projects

```bash
# Initialize new project
uv init my-project
cd my-project

# Initialize with specific Python version
uv init --python 3.12 my-project
```

#### Working with Existing Projects

```bash
# Sync project dependencies
uv sync

# Add new dependency
uv add fastapi

# Add development dependency
uv add --dev black isort

# Remove dependency
uv remove fastapi

# Run project commands
uv run python main.py
uv run pytest
uv run black .
```

### 5. Script Execution

UV can run Python scripts with automatic dependency management:

```bash
# Run a script (UV will handle dependencies)
uv run script.py

# Run with specific dependencies
uv run --with requests script.py

# Run script with inline dependencies
uv run --with "requests>=2.25.0" script.py
```

### 6. Tool Management

UV can install and run Python tools:

```bash
# Install a tool globally
uv tool install ruff

# Run a tool
uv tool run ruff check .

# List installed tools
uv tool list

# Uninstall a tool
uv tool uninstall ruff
```

## Project Structure

A typical UV project structure:

```
my-project/
├── pyproject.toml          # Project configuration
├── uv.lock                 # Lock file (auto-generated)
├── .venv/                  # Virtual environment
├── src/
│   └── my_project/
│       ├── __init__.py
│       └── main.py
└── tests/
    └── test_main.py
```

### pyproject.toml Example

```toml
[project]
name = "my-project"
version = "0.1.0"
description = "My awesome project"
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
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=6.0.0",
    "black>=22.0.0",
    "ruff>=0.1.0",
]
```

## Best Practices

### 1. Project Setup

```bash
# Always start with UV initialization
uv init my-project
cd my-project

# Use specific Python version
uv python pin 3.12

# Add core dependencies
uv add requests flask sqlalchemy

# Add development dependencies
uv add --dev pytest black ruff mypy
```

### 2. Dependency Management

```bash
# Always use UV commands instead of pip
uv add package-name          # Instead of pip install
uv remove package-name       # Instead of pip uninstall
uv sync                      # Instead of pip install -r requirements.txt

# Never edit pyproject.toml directly for dependencies
# Always use: uv add/remove commands
```

### 3. Environment Management

```bash
# Use UV's built-in environment management
uv run python script.py      # Instead of activating venv manually
uv run pytest               # Instead of source .venv/bin/activate && pytest
uv run black .              # Instead of source .venv/bin/activate && black .
```

### 4. Development Workflow

```bash
# Daily development workflow
uv sync                      # Sync dependencies
uv run python main.py       # Run your application
uv run pytest              # Run tests
uv run black .              # Format code
uv run ruff check .         # Lint code
```

## Advanced Features

### 1. Workspaces

For large projects with multiple packages:

```bash
# Create workspace
uv init --workspace my-workspace
cd my-workspace

# Add workspace members
uv init --package backend
uv init --package frontend
uv init --package shared
```

### 2. Publishing Packages

```bash
# Build package
uv build

# Publish to PyPI
uv publish

# Publish to private registry
uv publish --index-url https://your-registry.com/simple/
```

### 3. Custom Index URLs

```bash
# Add custom package index
uv add --index-url https://your-registry.com/simple/ private-package

# Use multiple indexes
uv add --extra-index-url https://pypi.org/simple/ package-name
```

## Comparison with Other Tools

| Feature | UV | pip | Poetry | Conda |
|---------|----|----|---------|-------|
| Speed | ⚡ 10-100x faster | 🐌 Slow | 🐌 Slow | 🐌 Slow |
| Python Management | ✅ Built-in | ❌ No | ❌ No | ✅ Built-in |
| Lock Files | ✅ Universal | ❌ No | ✅ Poetry-specific | ✅ Conda-specific |
| Virtual Environments | ✅ Auto-managed | ⚠️ Manual | ✅ Auto-managed | ✅ Built-in |
| Script Execution | ✅ With deps | ❌ No | ❌ No | ❌ No |
| Tool Management | ✅ Built-in | ❌ No | ❌ No | ❌ No |

## Troubleshooting

### Common Issues

**1. Installation Problems**
```bash
# If curl installation fails, try pip
pip install uv

# Or use the Windows PowerShell method
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**2. Permission Issues**
```bash
# Make sure UV is in your PATH
echo $PATH | grep -i uv

# Or use the full path
~/.local/bin/uv --version
```

**3. Dependency Conflicts**
```bash
# Clear cache and reinstall
uv cache clean
uv sync --reinstall

# Check dependency tree
uv tree
```

**4. Python Version Issues**
```bash
# List available Python versions
uv python list

# Install specific version
uv python install 3.12

# Pin project to version
uv python pin 3.12
```

### Performance Tips

1. **Use UV's built-in commands** instead of pip
2. **Keep dependencies minimal** to reduce resolution time
3. **Use lock files** for reproducible builds
4. **Leverage global cache** for faster installs

## Migration Guide

### From pip + virtualenv

```bash
# Old way
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# New way with UV
uv venv
uv sync
```

### From Poetry

```bash
# Old way
poetry install
poetry run python script.py

# New way with UV
uv sync
uv run python script.py
```

### From Conda

```bash
# Old way
conda create -n myenv python=3.12
conda activate myenv
conda install package-name

# New way with UV
uv python install 3.12
uv venv --python 3.12
uv add package-name
```

## Resources

- **Official Documentation**: [https://docs.astral.sh/uv/](https://docs.astral.sh/uv/)
- **GitHub Repository**: [https://github.com/astral-sh/uv](https://github.com/astral-sh/uv)
- **Installation Guide**: [https://docs.astral.sh/uv/getting-started/installation/](https://docs.astral.sh/uv/getting-started/installation/)
- **Project Management**: [https://docs.astral.sh/guides/projects/](https://docs.astral.sh/guides/projects/)
- **Script Execution**: [https://docs.astral.sh/guides/scripts/](https://docs.astral.sh/guides/scripts/)
- **Python Management**: [https://docs.astral.sh/guides/install-python/](https://docs.astral.sh/guides/install-python/)

## Conclusion

UV represents the future of Python package management, offering unprecedented speed and comprehensive functionality. By combining the best features of pip, Poetry, virtualenv, and more into a single, fast tool, UV streamlines Python development workflows.

**Key Takeaways:**
- UV is 10-100x faster than traditional tools
- Provides comprehensive project and dependency management
- Includes built-in Python version management
- Offers seamless script execution with dependency handling
- Supports modern Python packaging standards
- Reduces complexity while increasing performance

Start using UV today to experience faster, more reliable Python package management!
