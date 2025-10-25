# Awesome Things Repository Instructions

## Project Overview

This repository contains comprehensive guides and documentation for modern development tools and practices. The project focuses on providing high-quality, production-ready documentation for essential development workflows, with particular emphasis on Python development using UV package manager, Docker containerisation, prompt engineering excellence, and automation playbooks that leverage Perplexity research and n8n orchestration.

## Technology Stack

- **Documentation**: Markdown with comprehensive guides and examples
- **Python Development**: UV package manager for fast dependency management
- **Containerisation**: Docker with multi-stage builds and UV integration
- **CI/CD**: GitHub Actions with automated testing and deployment
- **Development Tools**: Modern Python tooling with UV, Docker, and best practices
- **Prompt Engineering & Automation**: Perplexity research workflows, reusable prompt templates, and n8n workflow orchestration

## Repository Structure

```
awesome_things/
├── docs/                    # Comprehensive documentation guides
│   ├── github-instructions-guide.md    # GitHub Copilot instructions guide
│   ├── github-chatmodes-guide.md       # GitHub chatmodes guide
│   ├── docker-uv-guide.md              # Docker + UV Python guide
│   └── [other guides]                  # Additional documentation
├── .github/                 # GitHub workflows and configurations
│   ├── copilot-instructions.md         # This file
│   └── workflows/                      # CI/CD pipelines
└── [other files]          # Additional project files
```

## Development Standards

### Documentation Standards

- **British English**: Use British spelling throughout (colour, organise, centre, etc.)
- **Comprehensive Coverage**: Provide complete, production-ready documentation
- **Practical Examples**: Include real-world, working examples
- **Best Practices**: Follow industry standards and modern conventions
- **Clear Structure**: Use consistent formatting and organisation

### Python Development (when applicable)

- **UV Package Manager**: Always use UV for Python package management
- **Docker Integration**: Use multi-stage Docker builds with UV
- **Type Safety**: Use TypeScript-style type hints and strict typing
- **Testing**: Comprehensive test coverage with pytest
- **Code Quality**: Use black, isort, mypy, and flake8

### Docker Standards

- **Multi-Stage Builds**: Separate build and runtime stages
- **UV Integration**: Use UV for fast dependency resolution
- **Security**: Non-root users and minimal base images
- **Performance**: Optimised layer caching and bytecode compilation
- **Production Ready**: Health checks and proper error handling

## Coding Conventions

### Markdown Documentation

- Use proper heading hierarchy (H1 for main title, H2 for sections, etc.)
- Include table of contents for longer documents
- Use code fences with appropriate language tags
- Provide comprehensive examples with explanations
- Include troubleshooting sections for common issues

### File Organisation

- Group related documentation in logical directories
- Use descriptive, clear file names
- Maintain consistent structure across similar files
- Include metadata and frontmatter where appropriate

### Content Quality

- **Accuracy**: Ensure all information is current and correct
- **Completeness**: Cover all aspects of the topic thoroughly
- **Clarity**: Write for intelligent, technical audiences
- **Practicality**: Focus on actionable, implementable guidance
- **Examples**: Provide working code examples and configurations

## Project-Specific Guidelines

### Documentation Creation

1. **Research Phase**: Use comprehensive research with multiple sources
2. **Analysis Phase**: Identify key concepts and best practices
3. **Implementation Phase**: Create well-structured, practical documentation
4. **Quality Assurance**: Ensure accuracy, completeness, and clarity

### Guide Structure

- **Overview**: Clear introduction and purpose
- **Prerequisites**: Requirements and setup instructions
- **Implementation Guide**: Step-by-step instructions
- **Examples**: Practical code examples and configurations
- **Best Practices**: Recommended approaches and patterns
- **Troubleshooting**: Common issues and solutions
- **Resources**: Links to additional information

### Technology Integration

- **UV Python**: Default to UV for all Python package management
- **Docker**: Use modern Docker patterns with UV integration
- **GitHub Features**: Leverage GitHub Copilot, instructions, and chatmodes
- **CI/CD**: Implement automated testing and deployment pipelines
- **Prompt Engineering**: Apply repository personas, templates, and reasoning scaffolds so AI outputs follow our standards
- **Research**: Use multi-source validation with Perplexity per `docs/perplexity-search-optimisation-guide.md` to keep content current

## Research & Intelligence Workflow

1. **Define Scope**: Capture objectives, constraints, deliverables, and success metrics before drafting content or code.
2. **Source Triangulation**: Consult at least two authoritative sources—official docs, RFCs, internal guides—and log the prompts/queries used.
3. **Evidence Journaling**: Record citations, insights, and open questions directly in your working notes or pull request descriptions to keep work auditable.
4. **Insight Validation**: Cross-check guidance against UV, Docker, GitHub, and security standards; flag deprecated patterns with modern replacements.
5. **Knowledge Transfer**: Link to supporting guides (UV, Docker, GitHub, prompt, n8n) and describe the recommended next verification step when uncertainties remain.

### Research Tooling

- **Perplexity Search Optimisation** (`docs/perplexity-search-optimisation-guide.md`): Structure effective queries, evaluate citations, and capture research metadata.
- **Prompt Generation Best Practices** (`docs/prompt-generation-best-practices-guide.md`): Design personas, specify outputs, and incorporate chain-of-thought scaffolding.
- **Automation Hooks** (`docs/n8n-workflow-best-practices-guide.md`): Convert repeatable research or validation flows into versioned n8n workflows with secrets isolation.

## Security and Performance

### Security Considerations

- Use non-root users in Docker containers
- Implement proper authentication and authorisation
- Follow OWASP security best practices
- Use minimal base images and distroless containers
- Regular security scanning and dependency updates

### Performance Optimisation

- Leverage UV's 10-100x faster dependency resolution
- Use multi-stage Docker builds for smaller images
- Implement proper caching strategies
- Optimise layer caching for faster builds
- Use bytecode compilation for faster startup times

## Prompt Engineering Standards

- **Persona Precision**: Define the assistant’s role, expertise, and tone so responses align with project expectations.
- **Structured Output**: Specify headings, bullet styles, fenced code, and line references to minimise editing.
- **Reasoning Transparency**: Request step-by-step explanations or validation checklists for complex tasks.
- **Iterative Refinement**: Capture prompt revisions, note what improved, and upstream reusable templates to `.cursor/commands` or docs.

## Automation & Workflow Integration

- **n8n Alignment**: Follow `docs/n8n-workflow-best-practices-guide.md` for idempotent nodes, encrypted credentials, observability, and rollback plans.
- **UV & Docker Awareness**: Ensure automation triggers respect UV-managed dependencies and Docker build expectations (caching, non-root users, health checks).
- **Traceability**: Version workflow definitions, document required environment variables, and link each automation to its source documentation or instruction set.
- **Interoperable Outputs**: Prefer JSON or Markdown so workflow artefacts feed directly into docs, GitHub Actions, or Copilot chat contexts.

## Quality Standards

### Documentation Quality

- **Comprehensive**: Cover all aspects of the topic
- **Accurate**: Ensure all information is correct and current
- **Practical**: Provide actionable, implementable guidance
- **Professional**: Use proper formatting and structure
- **Accessible**: Write for technical audiences with deep knowledge

### Code Quality (when applicable)

- **Type Safety**: Use proper type hints and strict typing
- **Testing**: Comprehensive test coverage
- **Linting**: Use black, isort, mypy, and flake8
- **Documentation**: Include docstrings and comments
- **Performance**: Optimise for speed and efficiency

## Development Workflow

### Local Development

1. Use UV for Python package management
2. Implement Docker for containerisation
3. Follow documentation standards and conventions
4. Test all examples and configurations
5. Ensure quality and accuracy

### CI/CD Pipeline

1. Automated testing and quality checks
2. Docker image building and testing
3. Security scanning and dependency updates
4. Documentation validation and deployment
5. Performance monitoring and optimisation

## Best Practices

### Documentation Best Practices

- Start with comprehensive research
- Provide practical, working examples
- Include troubleshooting sections
- Maintain consistency across guides
- Regular updates and improvements

### Technical Best Practices

- Use modern tools and practices
- Implement proper error handling
- Follow security best practices
- Optimise for performance
- Ensure maintainability and scalability

## Common Patterns

### Documentation Patterns

- **Guide Structure**: Overview → Prerequisites → Implementation → Examples → Best Practices → Troubleshooting → Resources
- **Code Examples**: Working, tested examples with explanations
- **Configuration**: Complete, production-ready configurations
- **Troubleshooting**: Common issues with specific solutions

### Technical Patterns

- **UV Integration**: Fast dependency management with Docker
- **Multi-Stage Builds**: Optimised Docker images
- **Security**: Non-root users and minimal images
- **Performance**: Caching and optimisation strategies

## Error Handling and Troubleshooting

### Common Issues

- **Docker Build Issues**: Check UV environment variables and cache settings
- **Documentation Issues**: Verify examples and test configurations
- **Performance Issues**: Optimise Docker layers and UV cache
- **Security Issues**: Implement proper user permissions and scanning

### Debugging Approaches

- **Systematic Analysis**: Identify 6-8 most probable solutions
- **Prioritisation**: Focus on most likely solutions first
- **Verification**: Test solutions and confirm effectiveness
- **Documentation**: Update guides with solutions and improvements

## Resources and References

### Official Documentation

- **UV Documentation**: <https://docs.astral.sh/uv/>
- **Docker Documentation**: <https://docs.docker.com/>
- **GitHub Copilot**: <https://docs.github.com/en/copilot/>
- **GitHub Actions**: <https://docs.github.com/en/actions>

### Community Resources

- **UV GitHub**: <https://github.com/astral-sh/uv>
- **Docker Hub**: <https://hub.docker.com/>
- **GitHub Awesome**: <https://github.com/github/awesome-copilot>
- **Best Practices**: Industry standards and modern conventions

### Internal Repository Guides

- `docs/uv-python-guide.md`: UV project setup, dependency management, tooling standards
- `docs/docker-uv-guide.md`: Multi-stage Docker builds, UV integration, caching, and security guardrails
- `docs/github-instructions-guide.md` & `docs/github-chatmodes-guide.md`: GitHub custom instructions, chat modes, and prompt governance
- `docs/github-actions-cicd-guide.md` & `docs/github-actions-secrets-guide.md`: CI/CD workflows, secrets hygiene, and automation guardrails
- `docs/prompt-generation-best-practices-guide.md`: Prompt templates, reasoning scaffolds, and validation techniques
- `docs/perplexity-search-optimisation-guide.md`: Research flows, search heuristics, and citation expectations
- `docs/n8n-workflow-best-practices-guide.md`: Automation architecture, reliability engineering, and operations checklists

---

*These instructions provide comprehensive guidance for developing high-quality documentation and technical guides using modern tools and best practices. Focus on accuracy, completeness, and practical applicability in all work.*
