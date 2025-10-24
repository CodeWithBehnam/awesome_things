# Awesome Things

A comprehensive collection of awesome development tools, resources, and documentation that make development and life better. This repository serves as both a curated collection of useful resources and a practical guide for modern development workflows.

## 🚀 What's Inside

### 📚 Documentation
- **[Cursor IDE .cursor Folder Guide](docs/cursor-folder-guide.md)** - Complete guide to customizing Cursor IDE with rules and commands
- **[UV Python Package Manager Guide](docs/uv-python-guide.md)** - Comprehensive guide to using UV for Python development

### 🛠️ Cursor IDE Configuration
This repository includes a complete Cursor IDE setup with custom rules and commands:

#### **Rules (`.cursor/rules/`)**
- **`global.mdc`** - Global project rules and coding standards
- **`uv-python.mdc`** - UV Python package manager development standards

#### **Commands (`.cursor/commands/`)**
- **`generate-docs.md`** - Automatically research and generate comprehensive documentation
- **`update-docs.md`** - Update existing documentation with latest information
- **`create-rules-commands.md`** - Create custom Cursor rules and commands
- **`setup-uv-project.md`** - Initialize new Python projects with UV
- **`uv-development-workflow.md`** - Execute comprehensive UV development workflows

### 🎯 Key Features

#### **Cursor IDE Integration**
- **Custom Rules** - Project-specific coding standards and best practices
- **Slash Commands** - Streamlined workflows for common development tasks
- **MCP Tool Integration** - Automated research using Ref MCP and Exa MCP
- **Documentation Generation** - AI-powered documentation creation and updates

#### **UV Python Development**
- **Modern Package Management** - 10-100x faster than traditional tools
- **Comprehensive Workflows** - Complete development lifecycle management
- **Best Practices** - Industry-standard Python development patterns
- **Project Templates** - Ready-to-use project configurations

## 🏗️ Repository Structure

```
awesome_things/
├── docs/                           # Comprehensive documentation
│   ├── cursor-folder-guide.md     # Cursor IDE configuration guide
│   └── uv-python-guide.md         # UV Python package manager guide
├── .cursor/                        # Cursor IDE configuration
│   ├── rules/                      # Custom development rules
│   │   ├── global.mdc             # Global project standards
│   │   └── uv-python.mdc          # UV Python development rules
│   └── commands/                   # Custom slash commands
│       ├── generate-docs.md       # Documentation generation
│       ├── update-docs.md         # Documentation updates
│       ├── create-rules-commands.md # Rule and command creation
│       ├── setup-uv-project.md    # Project initialization
│       └── uv-development-workflow.md # Development workflows
├── .gitignore                     # Git ignore configuration
└── README.md                      # This file
```

## 🚀 Quick Start

### Using Cursor IDE Commands

1. **Generate Documentation:**
   ```
   /generate-docs Create comprehensive documentation about [topic]
   ```

2. **Update Documentation:**
   ```
   /update-docs Update the existing documentation with latest information
   ```

3. **Create Rules and Commands:**
   ```
   /create-rules-commands Create rules and commands for [technology/framework]
   ```

4. **Setup UV Python Project:**
   ```
   /setup-uv-project Create a new FastAPI web application with testing tools
   ```

5. **UV Development Workflow:**
   ```
   /uv-development-workflow Run daily development tasks including code quality checks
   ```

### Using UV Python Package Manager

1. **Install UV:**
   ```bash
   curl -LsSf https://astral.sh/uv/install.sh | sh
   ```

2. **Create New Project:**
   ```bash
   uv init my-project
   cd my-project
   uv python pin 3.12
   ```

3. **Add Dependencies:**
   ```bash
   uv add requests flask sqlalchemy
   uv add --dev pytest black ruff mypy
   ```

4. **Run Development Tasks:**
   ```bash
   uv run python main.py
   uv run pytest
   uv run black .
   uv run ruff check .
   ```

## 📖 Documentation Highlights

### Cursor IDE Guide
- **Complete .cursor folder structure** with rules and commands
- **MCP tool integration** for automated research and documentation
- **Best practices** for team collaboration and code quality
- **Custom workflows** for streamlined development

### UV Python Guide
- **Modern package management** with 10-100x speed improvements
- **Comprehensive project setup** with best practices
- **Development workflows** for all project types
- **Migration guides** from pip, Poetry, and Conda

## 🛠️ Technologies Covered

- **Cursor IDE** - AI-powered code editor with custom rules and commands
- **UV Python** - Modern Python package manager written in Rust
- **MCP Tools** - Ref MCP and Exa MCP for automated research
- **Python Development** - Web apps, APIs, data science, CLI tools
- **Code Quality** - Black, Ruff, MyPy, pytest, pre-commit hooks

## 🎯 Use Cases

### For Developers
- **Streamline development workflows** with custom Cursor commands
- **Modernize Python development** with UV package manager
- **Automate documentation** generation and updates
- **Standardize team practices** with shared rules and commands

### For Teams
- **Consistent development environments** across team members
- **Automated code quality** checks and standards
- **Comprehensive documentation** for onboarding and reference
- **Best practices** for modern Python development

### For Projects
- **Quick project setup** with UV and Cursor integration
- **Comprehensive documentation** generation and maintenance
- **Quality assurance** with automated checks and standards
- **Scalable development** workflows for any project size

## 🤝 Contributing

We welcome contributions to make this collection even more awesome! Here's how you can contribute:

### Adding New Content
1. **Fork the repository**
2. **Add your awesome discovery** to the appropriate section
3. **Update documentation** if needed
4. **Submit a pull request** with a clear description

### Improving Existing Content
1. **Identify areas for improvement** in documentation or rules
2. **Make your changes** following the established patterns
3. **Test your changes** to ensure they work correctly
4. **Submit a pull request** with details about your improvements

### Creating New Rules and Commands
1. **Follow the established patterns** in existing rules and commands
2. **Include comprehensive documentation** and examples
3. **Test thoroughly** to ensure they work as expected
4. **Submit a pull request** with your new additions

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- **Cursor IDE** - For providing an amazing AI-powered development environment
- **UV Python** - For revolutionizing Python package management
- **Astral** - For creating incredible Rust-based Python tools
- **Community** - For sharing awesome tools and resources

## 🔗 Links

- **Repository**: [https://github.com/CodeWithBehnam/awesome_things](https://github.com/CodeWithBehnam/awesome_things)
- **Cursor IDE**: [https://cursor.com](https://cursor.com)
- **UV Python**: [https://docs.astral.sh/uv/](https://docs.astral.sh/uv/)
- **MCP Tools**: [https://docs.ref.tools/](https://docs.ref.tools/)

---

**Made with ❤️ for the developer community**
