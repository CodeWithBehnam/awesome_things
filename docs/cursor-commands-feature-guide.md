# Cursor Custom Commands Guide: Mastering `.cursor/commands`

## Table of Contents

1. [Overview](#overview)
2. [Getting Started](#getting-started)
3. [Command Structure](#command-structure)
4. [Creating Your First Command](#creating-your-first-command)
5. [Advanced Command Patterns](#advanced-command-patterns)
6. [Useful Command Examples](#useful-command-examples)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)
9. [Resources](#resources)

## Overview

Cursor's custom commands feature (introduced in version 1.6) allows you to create reusable prompts and quickly share them with your team. Commands are stored as Markdown files in the `.cursor/commands/` directory and can be invoked by typing `/` in the chat input box.

### Key Benefits

- **Reusable Prompts**: Save frequently used instructions as commands
- **Team Collaboration**: Share commands across your development team
- **Workflow Automation**: Streamline common development tasks
- **Consistency**: Ensure consistent AI behaviour across projects
- **Productivity**: Reduce repetitive typing and context switching

### How Commands Work

Commands are defined as plain Markdown files stored in the `.cursor/commands` directory of your project. When you type `/` in the chat input box, Cursor automatically detects and displays available commands from this directory.

## Getting Started

### Prerequisites

- Cursor IDE version 1.6 or later
- Basic understanding of Markdown syntax
- Familiarity with Cursor's chat interface

### Setup

1. **Create the commands directory**:
   ```bash
   mkdir -p .cursor/commands
   ```

2. **Verify Cursor version**:
   - Open Cursor
   - Check version in Help → About Cursor
   - Ensure you're running version 1.6 or later

3. **Test command detection**:
   - Open chat interface (`Ctrl/Cmd + L`)
   - Type `/` to see available commands
   - You should see a dropdown with your custom commands

## Command Structure

### Directory Structure

```
.cursor/
└── commands/
    ├── command-name.md
    ├── another-command.md
    └── subdirectory/
        └── nested-command.md
```

### File Naming Convention

- **Use descriptive names**: `code-review.md`, `write-tests.md`, `fix-bugs.md`
- **Use hyphens for spaces**: `create-pr.md` instead of `create pr.md`
- **Keep names concise**: Avoid overly long filenames
- **Use lowercase**: Follow standard naming conventions

### Markdown File Structure

Commands are written in plain Markdown with the following recommended structure:

```markdown
# Command Title

Brief description of what this command does.

## Purpose
Detailed explanation of the command's purpose and when to use it.

## Instructions
Step-by-step instructions for the AI to follow.

## Examples
Practical examples of how to use this command.

## Constraints
Any limitations or specific requirements.
```

## Creating Your First Command

### Example: Code Review Command

Create a file named `.cursor/commands/code-review.md`:

```markdown
# Code Review

Perform a comprehensive code review of the selected code or current file.

## Purpose
This command helps identify potential issues, improvements, and best practices violations in code.

## Instructions
1. Analyse the provided code for:
   - Code quality and readability
   - Performance optimisations
   - Security vulnerabilities
   - Best practices adherence
   - Potential bugs or edge cases

2. Provide specific, actionable feedback
3. Suggest improvements with code examples
4. Rate the code quality on a scale of 1-10
5. Highlight any critical issues that need immediate attention

## Examples
- Review a specific function: Select the function and use `/code-review`
- Review entire file: Use `/code-review` without selection
- Review multiple files: Use `/code-review` in Composer mode

## Constraints
- Focus on constructive feedback
- Provide specific line numbers when referencing issues
- Include both positive aspects and areas for improvement
```

### Testing Your Command

1. **Save the file** in `.cursor/commands/`
2. **Open chat interface** (`Ctrl/Cmd + L`)
3. **Type `/`** to see your command in the dropdown
4. **Select your command** and test it with some code

## Advanced Command Patterns

### 1. Context-Aware Commands

Commands can reference specific files, functions, or project context:

```markdown
# Database Migration

Create a database migration for the current changes.

## Instructions
1. Analyse the current database schema in `@database/schema.sql`
2. Review the changes in `@src/models/` directory
3. Create appropriate migration files following the pattern in `@migrations/`
4. Include both up and down migration scripts
5. Add proper error handling and rollback procedures

## Examples
- Create migration for new table: `/database-migration` with table definition
- Modify existing table: `/database-migration` with schema changes
```

### 2. Multi-Step Workflow Commands

Commands can orchestrate complex workflows:

```markdown
# Feature Implementation

Implement a complete feature from specification to testing.

## Instructions
1. **Analysis Phase**:
   - Review the feature specification
   - Identify required components and dependencies
   - Plan the implementation approach

2. **Implementation Phase**:
   - Create necessary files and components
   - Implement core functionality
   - Add proper error handling

3. **Testing Phase**:
   - Write unit tests for new functionality
   - Add integration tests if needed
   - Ensure test coverage meets standards

4. **Documentation Phase**:
   - Update API documentation
   - Add inline code comments
   - Update README if necessary

## Examples
- Implement new API endpoint: `/feature-implementation` with endpoint specification
- Add new UI component: `/feature-implementation` with component requirements
```

### 3. Conditional Commands

Commands that adapt based on context:

```markdown
# Smart Refactor

Intelligently refactor code based on the current context and project patterns.

## Instructions
1. **Context Analysis**:
   - Identify the programming language and framework
   - Review existing code patterns in the project
   - Understand the current code's purpose

2. **Refactoring Strategy**:
   - For JavaScript/TypeScript: Apply modern ES6+ patterns
   - For Python: Follow PEP 8 and use type hints
   - For React: Use hooks and functional components
   - For backend code: Apply SOLID principles

3. **Implementation**:
   - Refactor while maintaining functionality
   - Improve readability and maintainability
   - Add proper error handling
   - Update related tests

## Examples
- Refactor legacy JavaScript: `/smart-refactor` on old ES5 code
- Modernise Python code: `/smart-refactor` on Python 2.x code
```

## Useful Command Examples

### Development Workflow Commands

#### 1. Bug Fix Command

```markdown
# Fix Bug

Systematically debug and fix issues in the codebase.

## Instructions
1. **Reproduction**:
   - Identify the bug symptoms
   - Create a minimal reproduction case
   - Document the expected vs actual behaviour

2. **Root Cause Analysis**:
   - Trace through the code execution path
   - Identify the specific line causing the issue
   - Understand why the bug occurs

3. **Fix Implementation**:
   - Implement the minimal fix required
   - Ensure the fix doesn't break existing functionality
   - Add appropriate error handling

4. **Verification**:
   - Test the fix thoroughly
   - Add regression tests if needed
   - Document the fix for future reference

## Examples
- Fix runtime error: `/fix-bug` with error message
- Fix logic error: `/fix-bug` with incorrect output
```

#### 2. Test Generation Command

```markdown
# Generate Tests

Create comprehensive test suites for the selected code.

## Instructions
1. **Test Analysis**:
   - Identify the code's public interface
   - Determine testable units (functions, methods, components)
   - Identify edge cases and error conditions

2. **Test Implementation**:
   - Write unit tests for each public function
   - Include positive and negative test cases
   - Add integration tests for complex interactions
   - Ensure proper test isolation and setup

3. **Test Quality**:
   - Use descriptive test names
   - Include proper assertions
   - Add test documentation
   - Ensure good test coverage

## Examples
- Test React component: `/generate-tests` on component file
- Test API endpoint: `/generate-tests` on route handler
- Test utility function: `/generate-tests` on utility file
```

#### 3. Documentation Command

```markdown
# Add Documentation

Generate comprehensive documentation for code, APIs, and processes.

## Instructions
1. **Code Documentation**:
   - Add JSDoc/docstring comments to functions
   - Document parameters, return values, and exceptions
   - Include usage examples in comments

2. **API Documentation**:
   - Document endpoint URLs and methods
   - Specify request/response schemas
   - Include authentication requirements
   - Add example requests and responses

3. **Process Documentation**:
   - Document setup and installation steps
   - Include configuration instructions
   - Add troubleshooting guides
   - Create user guides for complex features

## Examples
- Document API: `/add-documentation` on API route files
- Document component: `/add-documentation` on React component
- Document utility: `/add-documentation` on utility functions
```

### Code Quality Commands

#### 4. Security Audit Command

```markdown
# Security Audit

Perform a comprehensive security review of the codebase.

## Instructions
1. **Vulnerability Assessment**:
   - Check for common security vulnerabilities (OWASP Top 10)
   - Review authentication and authorization mechanisms
   - Analyse data handling and validation
   - Check for sensitive data exposure

2. **Code Security Review**:
   - Review input validation and sanitisation
   - Check for SQL injection vulnerabilities
   - Analyse file upload and handling
   - Review error handling and information disclosure

3. **Recommendations**:
   - Provide specific security improvements
   - Suggest security best practices
   - Recommend security tools and libraries
   - Create security checklist for future development

## Examples
- Audit API endpoints: `/security-audit` on API routes
- Audit authentication: `/security-audit` on auth middleware
- Audit data handling: `/security-audit` on data processing code
```

#### 5. Performance Optimisation Command

```markdown
# Optimise Performance

Analyse and improve code performance across the application.

## Instructions
1. **Performance Analysis**:
   - Identify performance bottlenecks
   - Analyse database queries and N+1 problems
   - Review memory usage and garbage collection
   - Check for inefficient algorithms

2. **Optimisation Strategies**:
   - Implement caching where appropriate
   - Optimise database queries and indexes
   - Reduce bundle sizes and loading times
   - Implement lazy loading and code splitting

3. **Monitoring Setup**:
   - Add performance monitoring
   - Implement logging for performance metrics
   - Set up alerts for performance degradation
   - Create performance benchmarks

## Examples
- Optimise React app: `/optimise-performance` on frontend code
- Optimise API: `/optimise-performance` on backend endpoints
- Optimise database: `/optimise-performance` on query code
```

### Team Collaboration Commands

#### 6. PR Creation Command

```markdown
# Create PR

Generate a comprehensive pull request with proper description and conventional commits.

## Instructions
1. **Change Analysis**:
   - Review all modified files
   - Identify the scope and impact of changes
   - Categorise changes (feature, bugfix, refactor, etc.)

2. **PR Description**:
   - Write clear, concise title
   - Provide detailed description of changes
   - Include motivation and context
   - List any breaking changes

3. **Conventional Commits**:
   - Use proper commit message format
   - Include scope and description
   - Add body for complex changes
   - Reference related issues

## Examples
- Feature PR: `/create-pr` for new feature implementation
- Bugfix PR: `/create-pr` for bug fixes
- Refactor PR: `/create-pr` for code refactoring
```

#### 7. Onboarding Command

```markdown
# Onboard Developer

Help new team members understand the codebase and development workflow.

## Instructions
1. **Project Overview**:
   - Explain the project structure and architecture
   - Identify key components and their purposes
   - Highlight important configuration files
   - Explain the development workflow

2. **Setup Instructions**:
   - Provide step-by-step setup guide
   - List required dependencies and tools
   - Explain environment configuration
   - Include common troubleshooting steps

3. **Development Guidelines**:
   - Explain coding standards and conventions
   - Describe testing requirements
   - Outline code review process
   - Provide resources for learning

## Examples
- New developer setup: `/onboard-developer` for project introduction
- Feature explanation: `/onboard-developer` for specific feature
- Workflow explanation: `/onboard-developer` for development process
```

## Best Practices

### 1. Command Design

- **Single Responsibility**: Each command should have a clear, focused purpose
- **Descriptive Names**: Use names that clearly indicate the command's function
- **Comprehensive Instructions**: Provide detailed, step-by-step instructions
- **Include Examples**: Show practical usage scenarios
- **Define Constraints**: Specify limitations and requirements

### 2. Content Structure

- **Clear Headers**: Use proper Markdown headers for organisation
- **Consistent Format**: Follow a consistent structure across all commands
- **Actionable Instructions**: Write instructions that the AI can follow precisely
- **Context Awareness**: Reference project-specific files and patterns
- **Error Handling**: Include instructions for handling edge cases

### 3. Team Collaboration

- **Version Control**: Commit commands to your repository
- **Documentation**: Document command purposes and usage
- **Regular Updates**: Keep commands updated with project changes
- **Team Review**: Have team members review and improve commands
- **Sharing**: Share useful commands across projects

### 4. Performance Considerations

- **Concise Instructions**: Avoid overly verbose commands
- **Focused Scope**: Keep commands focused on specific tasks
- **Efficient Context**: Only reference necessary files and information
- **Clear Output**: Specify desired output format and structure

## Troubleshooting

### Common Issues

#### Commands Not Appearing

**Problem**: Commands don't show up in the dropdown when typing `/`

**Solutions**:
1. **Check directory structure**: Ensure `.cursor/commands/` exists in project root
2. **Verify file extensions**: Commands must have `.md` extension
3. **Restart Cursor**: Close and reopen Cursor to refresh command detection
4. **Check permissions**: Ensure files are readable by Cursor

#### Commands Not Working

**Problem**: Commands execute but don't produce expected results

**Solutions**:
1. **Review instructions**: Ensure instructions are clear and actionable
2. **Check context**: Verify referenced files and paths exist
3. **Test incrementally**: Start with simple commands and build complexity
4. **Review AI output**: Check if AI is following instructions correctly

#### Performance Issues

**Problem**: Commands take too long to execute or consume too much context

**Solutions**:
1. **Simplify instructions**: Break complex commands into smaller ones
2. **Reduce context**: Limit file references and context size
3. **Optimise prompts**: Use more efficient prompt structures
4. **Split workflows**: Divide complex workflows into multiple commands

### Debugging Tips

1. **Test Commands**: Always test commands before sharing with team
2. **Monitor Context**: Watch context usage in complex commands
3. **Iterate Improvements**: Continuously improve command effectiveness
4. **Document Issues**: Keep track of common problems and solutions

## Resources

### Official Documentation
- [Cursor Commands Documentation](https://docs.cursor.com/en/agent/chat/commands)
- [Cursor Changelog 1.6](https://cursor.com/changelog/1-6)
- [Cursor Rules Documentation](https://docs.cursor.com/en/context/rules)

### Community Resources
- [hamzafer/cursor-commands](https://github.com/hamzafer/cursor-commands) - Popular command collection
- [Cursor Forum](https://forum.cursor.com/) - Community discussions
- [Awesome Cursor Rules](https://github.com/sanjeed5/awesome-cursor-rules-mdc) - Rules and commands

### Learning Resources
- [Cursor 101](https://cursor101.com/) - Learning platform
- [Cursor Cheat Sheet](https://cursorcheatsheet.com/) - Quick reference
- [Advanced Cursor Techniques](https://educative.io/courses/advanced-cursor-ai)

### Command Collections
- [Cursor Commands Repository](https://github.com/hamzafer/cursor-commands) - 20+ ready-to-use commands
- [Custom Commands Examples](https://github.com/jinho-kim-osd/cursor-commands) - Additional examples
- [Cursor Prompts Repository](https://github.com/rsproule/cursor-prompts) - Prompt collections

---

*This guide provides comprehensive coverage of Cursor's custom commands feature. Regular updates ensure compatibility with the latest Cursor releases and best practices.*
