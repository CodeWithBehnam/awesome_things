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

### 3. Example Structure
```
.cursor/
├── rules/
│   ├── global.mdc          # Global project rules
│   ├── python.mdc          # Python-specific rules
│   ├── fastapi.mdc         # FastAPI framework rules
│   ├── react.mdc           # React component rules
│   └── testing.mdc         # Testing guidelines
├── .cursorignore           # Files to ignore from indexing
└── .cursorindexingignore   # Files to exclude from indexing only
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

1. **Create the .cursor folder:**
   ```bash
   mkdir -p .cursor/rules
   ```

2. **Add your first rule file:**
   ```bash
   touch .cursor/rules/global.mdc
   ```

3. **Configure ignore files:**
   ```bash
   touch .cursor/.cursorignore
   ```

4. **Start with basic rules and expand as needed**

## Resources

- [Cursor Rules Documentation](https://cursor.com/docs/context/rules)
- [Awesome Cursor Rules](https://github.com/PatrickJS/awesome-cursorrules)
- [Cursor Rules Repository](https://github.com/sparesparrow/cursor-rules)

## Conclusion

The `.cursor` folder essentially acts as a "brain" for your project, telling Cursor's AI how to behave when working with your specific codebase, tech stack, and coding conventions. It's a powerful way to make Cursor more intelligent and context-aware for your particular project needs.

By properly configuring your `.cursor` folder, you can:
- Improve AI code generation quality
- Enforce consistent coding standards
- Optimize AI responses for your tech stack
- Enhance team collaboration and code quality
