# GitHub Prompts and Custom Instructions Guide

## Overview

GitHub Copilot's custom instructions and prompt files revolutionise how development teams interact with AI-powered coding assistance. These features enable teams to provide repository-specific context, enforce coding standards, and create reusable prompts for common development tasks, ensuring consistent, high-quality AI assistance across entire organisations.

This comprehensive guide covers both **custom instructions** (repository-wide context) and **prompt files** (reusable task-specific prompts), providing everything needed to implement these powerful customisation features effectively.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Understanding Custom Instructions](#understanding-custom-instructions)
- [Creating Repository Custom Instructions](#creating-repository-custom-instructions)
- [Understanding Prompt Files](#understanding-prompt-files)
- [Creating and Using Prompt Files](#creating-and-using-prompt-files)
- [Advanced Configuration](#advanced-configuration)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Prerequisites

### Required Tools and Access

- **GitHub Copilot subscription** (Individual, Business, or Enterprise)
- **VS Code** with GitHub Copilot extension (for prompt files)
- **JetBrains IDEs** with GitHub Copilot plugin (for prompt files)
- **Repository access** with write permissions for custom instructions

### Environment Support

| Feature | VS Code | JetBrains | Visual Studio | GitHub.com | Eclipse | Xcode |
|---------|---------|-----------|---------------|------------|---------|-------|
| Repository Custom Instructions | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Path-Specific Instructions | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| Agent Instructions (AGENTS.md) | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Prompt Files (.prompt.md) | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

## Understanding Custom Instructions

### Types of Custom Instructions

#### 1. Personal Custom Instructions

- Apply across all GitHub conversations
- Individual preferences and response styles
- Set via GitHub.com settings

#### 2. Repository Custom Instructions

- Apply to specific repositories
- Project-specific coding standards and frameworks
- Stored in `.github/copilot-instructions.md`

#### 3. Organisation Custom Instructions (Enterprise)

- Apply across entire organisations
- Organisation-wide preferences and security guidelines
- Set by organisation owners

#### 4. Path-Specific Instructions

- Apply to files matching specific paths
- Stored in `.github/instructions/**/NAME.instructions.md`
- Avoid overloading repository-wide instructions

### Priority Order

1. **Personal instructions** (highest priority)
2. **Repository instructions**
3. **Organisation instructions** (lowest priority)

All relevant instructions are combined and provided to Copilot.

## Creating Repository Custom Instructions

### Basic Setup

1. **Create the directory structure:**

```bash
mkdir -p .github
```

2. **Create the custom instructions file:**

```bash
touch .github/copilot-instructions.md
```

3. **Add your instructions in Markdown format:**

```markdown
# Repository Custom Instructions

## Project Overview
This is a Python web application using FastAPI and PostgreSQL.

## Coding Standards
- Use type hints for all function parameters and return values
- Follow PEP 8 style guidelines
- Use black for code formatting
- Write comprehensive docstrings for all public functions

## Framework Preferences
- Use FastAPI for API endpoints
- Use SQLAlchemy for database operations
- Use Pydantic for data validation
- Use pytest for testing

## Security Requirements
- Validate all user inputs
- Use environment variables for secrets
- Implement proper authentication
- Sanitise database queries to prevent SQL injection

## Testing Standards
- Write unit tests for all business logic
- Achieve minimum 90% test coverage
- Use pytest fixtures for test data
- Mock external dependencies
```

### Using Copilot Coding Agent to Generate Instructions

GitHub provides an automated way to generate comprehensive custom instructions:

1. Navigate to [github.com/copilot/agents](https://github.com/copilot/agents)
2. Select your repository from the dropdown
3. Use this prompt:

```markdown
Your task is to "onboard" this repository to Copilot coding agent by adding a .github/copilot-instructions.md file in the repository that contains information describing how a coding agent seeing it for the first time can work most efficiently.

You will do this task only one time per repository and doing a good job can SIGNIFICANTLY improve the quality of the agent's work, so take your time, think carefully, and search thoroughly before writing the instructions.

<Goals>
- Reduce the likelihood of a coding agent pull request getting rejected by the user due to generating code that fails the continuous integration build, fails a validation pipeline, or having misbehaviour.
- Minimise bash command and build failures.
- Allow the agent to complete its task more quickly by minimising the need for exploration using grep, find, str_replace_editor, and code search tools.
</Goals>

<Limitations>
- Instructions must be no longer than 2 pages.
- Instructions must not be task specific.
</Limitations>

<WhatToAdd>
Add the following high level details about the codebase to reduce the amount of searching the agent has to do to understand the codebase each time:
<HighLevelDetails>
- A summary of what the repository does.
- High level repository information, such as the size of the repo, the type of the project, the languages, frameworks, or target runtimes in use.
</HighLevelDetails>

Add information about how to build and validate changes so the agent does not need to search and find it each time.
<BuildInstructions>
- For each of bootstrap, build, test, run, lint, and any other scripted step, document the sequence of steps to take to run it successfully as well as the versions of any runtime or build tools used.
- Each command should be validated by running it to ensure that it works correctly as well as any preconditions and postconditions.
- Try cleaning the repo and environment and running commands in different orders and document errors and misbehaviour observed as well as any steps used to mitigate the problem.
- Run the tests and document the order of steps required to run the tests.
- Make a change to the codebase. Document any unexpected build issues as well as the workarounds.
- Document environment setup steps that seem optional but that you have validated are actually required.
- Document the time required for commands that failed due to timing out.
- When you find a sequence of commands that work for a particular purpose, document them in detail.
- Use language to indicate when something should always be done. For example: "always run npm install before building".
- Record any validation steps from documentation.
</BuildInstructions>

List key facts about the layout and architecture of the codebase to help the agent find where to make changes with minimal searching.
<ProjectLayout>
- A description of the major architectural elements of the project, including the relative paths to the main project files, the location of configuration files for linting, compilation, testing, and preferences.
- A description of the checks run prior to check in, including any GitHub workflows, continuous integration builds, or other validation pipelines.
- Document the steps so that the agent can replicate these itself.
- Any explicit validation steps that the agent can consider to have further confidence in its changes.
- Dependencies that aren't obvious from the layout or file structure.
- Finally, fill in any remaining space with detailed lists of the following, in order of priority: the list of files in the repo root, the contents of the README, the contents of any key source files, the list of files in the next level down of directories, giving priority to the more structurally important and snippets of code from key source files, such as the one containing the main method.
</ProjectLayout>
</WhatToAdd>
```

## Understanding Prompt Files

### What Are Prompt Files?

Prompt files (`.prompt.md`) are reusable Markdown files that define specific prompts for common development tasks. Unlike custom instructions that apply to all requests, prompt files are triggered on-demand for specific tasks.

### Key Features

- **Reusable prompts** for common development tasks
- **Task-specific guidelines** and context
- **Slash command integration** in VS Code and JetBrains
- **Variable support** for dynamic content
- **Tool integration** for enhanced capabilities

### Prompt File Types

#### 1. Workspace Prompt Files

- Stored in `.github/prompts/` directory
- Available to all team members
- Version controlled with repository

#### 2. User Prompt Files

- Stored in VS Code profile
- Available across all workspaces
- Synced via Settings Sync

## Creating and Using Prompt Files

### Basic Prompt File Structure

```markdown
---
mode: 'agent'
model: GPT-4o
tools: ['githubRepo', 'search/codebase']
description: 'Generate a new React form component'
---
Your goal is to generate a new React form component based on the templates in #githubRepo contoso/react-templates.

Ask for the form name and fields if not provided.

Requirements for the form:
- Use form design system components: [design-system/Form.md](../docs/design-system/Form.md)
- Use `react-hook-form` for form state management:
  - Always define TypeScript types for your form data
  - Prefer *uncontrolled* components using register
  - Use `defaultValues` to prevent unnecessary rerenders
- Use `yup` for validation:
  - Create reusable validation schemas in separate files
  - Use TypeScript types to ensure type safety
  - Customise UX-friendly validation rules
```

### YAML Frontmatter Options

| Field | Description | Options |
|-------|-------------|---------|
| `mode` | Chat mode for running the prompt | `ask`, `edit`, `agent` |
| `model` | Language model to use | `GPT-4o`, `Claude Sonnet 4`, etc. |
| `tools` | Array of available tools | Tool names from workspace |
| `description` | Short description of the prompt | Free text |

### Variable Support

Prompt files support several built-in variables:

#### Workspace Variables

- `${workspaceFolder}` - Full path to workspace
- `${workspaceFolderBasename}` - Workspace folder name

#### Selection Variables

- `${selection}` - Currently selected text
- `${selectedText}` - Alias for selection

#### File Context Variables

- `${file}` - Full path to current file
- `${fileBasename}` - Current file name
- `${fileDirname}` - Current file directory
- `${fileBasenameNoExtension}` - File name without extension

#### Input Variables

- `${input:variableName}` - User input with variable name
- `${input:variableName:placeholder}` - Input with placeholder text

### Creating Prompt Files

#### Method 1: VS Code Interface

1. Enable `chat.promptFiles` setting
2. In Chat view: **Configure Chat** > **Prompt Files** > **New prompt file**
3. Choose workspace or user location
4. Enter name and author content

#### Method 2: Command Palette

1. **Ctrl+Shift+P** (Windows/Linux) or **Cmd+Shift+P** (Mac)
2. Run **Chat: New Prompt File**
3. Follow the prompts

#### Method 3: Manual Creation

1. Create `.github/prompts/` directory
2. Create `.prompt.md` file
3. Add YAML frontmatter and content

### Using Prompt Files

#### Method 1: Slash Commands

Type `/` followed by the prompt file name:

```
/create-react-form
/create-react-form: formName=MyForm
```

#### Method 2: Command Palette

1. **Ctrl+Shift+P** (Windows/Linux) or **Cmd+Shift+P** (Mac)
2. Run **Chat: Run Prompt**
3. Select from available prompts

#### Method 3: Editor Play Button

1. Open prompt file in editor
2. Click play button in title area
3. Choose current or new chat session

## Advanced Configuration

### Path-Specific Instructions

Create instructions that apply only to specific file paths:

1. **Create instructions directory:**

```bash
mkdir -p .github/instructions
```

2. **Create path-specific instruction files:**

```bash
# For Python files
touch .github/instructions/python.instructions.md

# For frontend files
touch .github/instructions/frontend.instructions.md

# For configuration files
touch .github/instructions/config.instructions.md
```

3. **Add path-specific content:**

```markdown
# Python-specific instructions
- Use type hints for all function parameters
- Follow PEP 8 style guidelines
- Use black for code formatting
- Write comprehensive docstrings
```

### Agent Instructions (AGENTS.md)

For repositories using Copilot coding agent, create an `AGENTS.md` file:

```markdown
# Agent Instructions

## Project Context
This repository contains a microservices architecture with the following components:
- API Gateway (FastAPI)
- User Service (Django)
- Payment Service (Node.js)
- Database (PostgreSQL)

## Development Workflow
1. Always run tests before committing
2. Use conventional commit messages
3. Update documentation for API changes
4. Ensure backward compatibility for API changes

## Code Standards
- Use dependency injection for testability
- Implement proper error handling
- Use structured logging
- Follow security best practices
```

### Tool Integration

Configure tools for enhanced prompt capabilities:

```markdown
---
mode: 'agent'
tools: ['githubRepo', 'search/codebase', 'markdownlint', 'codebase']
description: 'Update documentation with new changes'
---
You are a documentation specialist.

Requirements for the README update:
- Use the existing README structure as a guide
- Ensure the new section is consistent with the current style and formatting
- Update the README.md file with the new changes
- Use markdownlint to ensure the updated README.md file is properly formatted
```

## Best Practices

### Writing Effective Custom Instructions

#### Do's

- **Keep instructions short and self-contained**
- **Use specific, actionable language**
- **Focus on project-specific requirements**
- **Include coding standards and conventions**
- **Specify frameworks and tools used**

#### Don'ts

- **Avoid overly complex instructions**
- **Don't reference external resources**
- **Avoid conflicting instructions**
- **Don't make instructions too specific to individual tasks**

### Effective Prompt File Design

#### Structure Guidelines

1. **Clear description** of what the prompt accomplishes
2. **Specific requirements** and constraints
3. **Expected output format**
4. **Examples** of input and output
5. **Reference to custom instructions** rather than duplicating guidelines

#### Content Best Practices

- **Use Markdown links** to reference other files
- **Leverage built-in variables** for flexibility
- **Test prompts** using the editor play button
- **Iterate and refine** based on results

### Team Collaboration

#### Repository-Level Instructions

- **Version control** all custom instructions
- **Review changes** through pull requests
- **Document rationale** for instruction changes
- **Regular updates** as project evolves

#### Prompt File Organisation

- **Use descriptive names** for prompt files
- **Group related prompts** in subdirectories
- **Document prompt purposes** in comments
- **Share successful prompts** with team

### Security Considerations

#### Sensitive Information

- **Never include secrets** in custom instructions
- **Use environment variables** for configuration
- **Avoid hardcoded credentials**
- **Review instructions** for security implications

#### Access Control

- **Limit repository access** to trusted team members
- **Use organisation-level instructions** for security policies
- **Regular audits** of custom instructions
- **Monitor for inappropriate content**

## Troubleshooting

### Common Issues

#### Custom Instructions Not Working

1. **Check file location** - Must be in `.github/copilot-instructions.md`
2. **Verify file format** - Must be valid Markdown
3. **Check file permissions** - Ensure file is readable
4. **Restart VS Code** - Sometimes required for changes to take effect

#### Prompt Files Not Appearing

1. **Enable setting** - Check `chat.promptFiles` is enabled
2. **Check file extension** - Must be `.prompt.md`
3. **Verify location** - Workspace prompts in `.github/prompts/`
4. **Restart VS Code** - Required for new prompt files

#### Conflicting Instructions

1. **Review priority order** - Personal > Repository > Organisation
2. **Check for contradictions** - Resolve conflicting instructions
3. **Simplify instructions** - Remove unnecessary complexity
4. **Test incrementally** - Add instructions one at a time

### Performance Optimisation

#### Instruction Length

- **Keep instructions concise** - Long instructions can impact performance
- **Focus on essential information** - Remove redundant content
- **Use path-specific instructions** - Avoid overloading repository-wide instructions

#### Prompt File Efficiency

- **Use variables effectively** - Reduce manual input requirements
- **Reference existing files** - Avoid duplicating content
- **Test prompt performance** - Ensure reasonable response times

### Debugging Techniques

#### Testing Custom Instructions

1. **Create test scenarios** - Simple tasks to verify instructions
2. **Check response quality** - Ensure instructions are being followed
3. **Iterate based on results** - Refine instructions as needed
4. **Document changes** - Track what works and what doesn't

#### Prompt File Validation

1. **Test with different inputs** - Verify variable substitution
2. **Check tool integration** - Ensure tools are available
3. **Validate output format** - Confirm expected results
4. **User feedback** - Gather team input on prompt effectiveness

## Resources

### Official Documentation

- [GitHub Copilot Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot)
- [VS Code Prompt Files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)
- [Custom Instructions Library](https://docs.github.com/en/copilot/tutorials/customization-library/custom-instructions)
- [Prompt Files Examples](https://docs.github.com/en/copilot/tutorials/customization-library/prompt-files)

### Community Resources

- [Awesome GitHub Copilot](https://github.com/github/awesome-copilot)
- [GitHub Copilot Tips and Tricks](https://code.visualstudio.com/docs/copilot/copilot-tips-and-tricks)
- [VS Code Copilot Customisation](https://code.visualstudio.com/docs/copilot/copilot-customization)

### Best Practice Guides

- [Writing Effective Custom Instructions](https://docs.github.com/en/copilot/concepts/prompting/response-customization#writing-effective-custom-instructions)
- [Prompt Engineering Best Practices](https://github.blog/ai-and-ml/github-copilot-prompt-engineering-best-practices)
- [Team Collaboration with Copilot](https://docs.github.com/en/copilot/customizing-copilot/adding-organization-custom-instructions-for-github-copilot)

### Example Repositories

- [GitHub Copilot Examples](https://github.com/github/awesome-copilot/tree/main/examples)
- [Custom Instructions Examples](https://github.com/github/awesome-copilot/tree/main/examples/custom-instructions)
- [Prompt Files Examples](https://github.com/github/awesome-copilot/tree/main/examples/prompt-files)

---

*This guide provides comprehensive coverage of GitHub Copilot's custom instructions and prompt files, enabling teams to maximise the value of AI-powered development assistance whilst maintaining consistency and quality across their codebases.*
