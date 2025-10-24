# Cursor IDE .cursor Folder Guide

## Overview

The `.cursor` folder is a special directory in Cursor IDE that contains configuration files to customize the AI assistant's behavior for your project. This guide explains what can be placed inside it and how to use it effectively.

## What Can Be Put Inside the `.cursor` Folder

### 1. Rules Directory (`.cursor/rules/`)

This is the most important subdirectory where you can place rule files:

- **`.mdc` files** - Markdown Cursor rule files with `.mdc` extension
- **Rule files for different scopes:**
  - Global rules (apply to entire project)
  - Language-specific rules (e.g., `python.mdc`, `javascript.mdc`)
  - Framework-specific rules (e.g., `react.mdc`, `fastapi.mdc`)
  - File-type specific rules (e.g., `components.mdc`, `services.mdc`)

### 2. Configuration Files

- **`.cursorignore`** - Controls which files Cursor can access for indexing
- **`.cursorindexingignore`** - Excludes files from indexing only (but keeps them accessible to AI)
- **Custom configuration files** for project-specific settings

### 3. Commands Directory (`.cursor/commands/`)

Custom slash commands for your project:

- **`.md` files** - Markdown files defining custom commands
- **Slash commands** - Type `/` in chat to see available commands
- **Project-specific workflows** - Tailored to your development process

### 4. Example Structure

```
.cursor/
├── rules/
│   ├── global.mdc          # Global project rules
│   ├── python.mdc          # Python-specific rules
│   ├── fastapi.mdc         # FastAPI framework rules
│   ├── react.mdc           # React component rules
│   └── testing.mdc         # Testing guidelines
├── commands/
│   ├── review-code.md      # /review-code command
│   ├── write-tests.md      # /write-tests command
│   ├── security-audit.md   # /security-audit command
│   └── create-pr.md        # /create-pr command
├── .cursorignore           # Files to ignore from indexing
└── .cursorindexingignore     # Files to exclude from indexing only
```

## Rule File Format (.mdc files)

Each rule file can contain:

- **YAML frontmatter** for metadata (scope, patterns, etc.)
- **Markdown content** with specific instructions
- **Code templates** and examples
- **Best practices** and conventions

### Example Rule File Structure

```yaml
---
name: "React Component Rules"
description: "Guidelines for React component development"
pattern: "src/components/**/*.{ts,tsx}"
---

# React Component Development Rules

## Component Structure
- Use functional components with TypeScript
- Define props interfaces clearly
- Use meaningful component names
- Follow single responsibility principle

## Code Style
- Use arrow functions for components
- Destructure props in function parameters
- Use const for component declarations
- Prefer named exports over default exports

## Best Practices
- Always include PropTypes or TypeScript interfaces
- Use React.memo for performance optimization when needed
- Keep components small and focused
- Use custom hooks for shared logic
```

## Commands Directory (`.cursor/commands/`)

The commands directory allows you to create **custom slash commands** that appear when you type `/` in the Cursor chat interface.

### How Commands Work

1. **Create the directory**: `.cursor/commands/`
2. **Add `.md` files** with descriptive names
3. **Write plain Markdown** describing what the command should do
4. **Commands automatically appear** when you type `/` in chat

### Command File Format

Each command file contains:

- **Plain Markdown content** describing what the command should do
- **No special syntax** required
- **Descriptive names** for the files (without the `.md` extension, this becomes the command name)

### Example Command Files

#### `review-code.md`

```markdown
# Code Review Command

Perform a comprehensive code review of the current changes:

1. Check for code quality issues
2. Verify best practices are followed
3. Look for potential bugs or security issues
4. Suggest improvements
5. Ensure proper error handling
6. Check for performance optimizations
```

#### `write-tests.md`

```markdown
# Write Tests Command

Generate comprehensive unit tests for the current code:

1. Analyze the code structure
2. Identify testable functions and methods
3. Create test cases for normal scenarios
4. Add edge case testing
5. Include error condition tests
6. Ensure proper test coverage
```

#### `security-audit.md`

```markdown
# Security Audit Command

Perform a security review of the codebase:

1. Check for common security vulnerabilities
2. Review authentication and authorization
3. Analyze input validation
4. Check for SQL injection risks
5. Review file upload security
6. Verify secure coding practices
```

### Popular Command Categories

- **Code Review**: `review-code.md`, `light-review.md`
- **Testing**: `write-tests.md`, `run-tests.md`
- **Documentation**: `add-documentation.md`, `generate-api-docs.md`
- **Security**: `security-audit.md`, `security-review.md`
- **Git/PR**: `create-pr.md`, `address-github-pr-comments.md`
- **Development**: `setup-new-feature.md`, `onboard-new-developer.md`
- **Debugging**: `debug-issue.md`, `fix-compile-errors.md`

### How to Use Commands

1. **Type `/`** in the Cursor chat
2. **See available commands** in the dropdown
3. **Select a command** to execute it
4. **The AI will follow** the instructions in the markdown file

## Key Benefits of Using .cursor Folder

### 1. Project-specific AI behavior

Customize how Cursor AI responds to your project's specific needs and conventions.

### 2. Team consistency

Share rules across team members to ensure consistent coding standards.

### 3. Framework optimization

Tailor AI responses to your specific tech stack and frameworks.

### 4. Code quality

Enforce coding standards and best practices automatically.

## Configuration Files Explained

### .cursorignore

Controls which files Cursor can access for codebase indexing and AI features.

**Example:**

```
# Ignore build outputs
dist/
build/
out/

# Ignore dependencies
node_modules/
__pycache__/

# Ignore sensitive files
.env
*.key
secrets.json
```

### .cursorindexingignore

Excludes files from indexing only but keeps them accessible to AI features.

**Example:**

```
# Exclude from indexing but keep accessible
docs/
*.md
README.md
```

## What NOT to Put in .cursor Folder

- Source code files
- Dependencies
- Build artifacts
- Large binary files
- Personal notes unrelated to AI configuration

## Best Practices

### 1. Organize Rules by Scope

- Create separate rule files for different languages/frameworks
- Use descriptive names for rule files
- Group related rules together

### 2. Keep Rules Focused

- Each rule file should have a specific purpose
- Avoid overly complex rules
- Update rules as your project evolves

### 3. Document Your Rules

- Include clear descriptions in rule files
- Add examples where helpful
- Keep rules maintainable and readable

### 4. Team Collaboration

- Share rule files with your team
- Review and update rules regularly
- Ensure rules align with project goals

## Getting Started

1. **Create the .cursor folder structure:**

   ```bash
   mkdir -p .cursor/rules
   mkdir -p .cursor/commands
   ```

2. **Add your first rule file:**

   ```bash
   touch .cursor/rules/global.mdc
   ```

3. **Add your first command:**

   ```bash
   touch .cursor/commands/review-code.md
   ```

4. **Configure ignore files:**

   ```bash
   touch .cursor/.cursorignore
   ```

5. **Start with basic rules and commands, then expand as needed**

## Resources

- [Cursor Rules Documentation](https://cursor.com/docs/context/rules)
- [Awesome Cursor Rules](https://github.com/PatrickJS/awesome-cursorrules)
- [Cursor Rules Repository](https://github.com/sparesparrow/cursor-rules)

## Conclusion

The `.cursor` folder essentially acts as a "brain" for your project, telling Cursor's AI how to behave when working with your specific codebase, tech stack, and coding conventions. It's a powerful way to make Cursor more intelligent and context-aware for your particular project needs.

By properly configuring your `.cursor` folder with rules and commands, you can:

- **Improve AI code generation quality** through targeted rules
- **Enforce consistent coding standards** across your team
- **Optimize AI responses** for your specific tech stack
- **Create custom workflows** with slash commands
- **Enhance team collaboration** and code quality
- **Standardize common tasks** with reusable commands

The combination of rules and commands creates a comprehensive AI assistant toolkit that's tailored to your project's specific needs and development workflow.
