# GitHub Repository Instructions Guide

A comprehensive guide to configuring GitHub Copilot with repository-specific custom instructions using `.github/instructions` files.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Types of Repository Instructions](#types-of-repository-instructions)
- [Implementation Guide](#implementation-guide)
- [Best Practices](#best-practices)
- [Examples](#examples)
- [Troubleshooting](#troubleshooting)
- [Resources](#resources)

## Overview

GitHub repository instructions provide a powerful way to customise GitHub Copilot's behaviour for your specific project. These instructions give Copilot additional context about your project's architecture, coding standards, and development practices, resulting in more accurate and relevant code suggestions.

### Key Benefits

- **Project-Specific Context**: Provide Copilot with detailed information about your project's structure, technologies, and conventions
- **Consistent Code Quality**: Ensure all team members receive similar, high-quality suggestions aligned with project standards
- **Reduced Context Switching**: Eliminate the need to repeatedly explain project-specific requirements in chat
- **Enhanced Productivity**: Get more relevant suggestions that match your project's patterns and best practices

### Support Matrix

| Environment | Repository-wide | Path-specific | Agent Instructions |
|------------|----------------|---------------|-------------------|
| VS Code | ✅ | ✅ | ✅ |
| GitHub.com | ✅ | ✅ | ✅ |
| JetBrains IDEs | ✅ | ❌ | ❌ |
| Visual Studio | ✅ | ❌ | ❌ |
| Eclipse | ✅ | ❌ | ❌ |
| Xcode | ✅ | ❌ | ❌ |

## Prerequisites

- GitHub Copilot subscription
- Repository access with write permissions
- Basic understanding of Markdown syntax
- Familiarity with your project's architecture and coding standards

## Types of Repository Instructions

### 1. Repository-Wide Instructions

Repository-wide instructions apply to all requests made within the repository context. These are stored in `.github/copilot-instructions.md`.

**Use Cases:**

- General project overview and architecture
- Universal coding standards and conventions
- Technology stack information
- Project-specific terminology and patterns

### 2. Path-Specific Instructions

Path-specific instructions apply only to files matching specified patterns. These are stored in `.github/instructions/**/NAME.instructions.md` files.

**Use Cases:**

- Language-specific coding standards
- Framework-specific patterns
- Directory-specific conventions
- Component-specific guidelines

### 3. Agent Instructions

Agent instructions are used by AI agents and can be stored in `AGENTS.md`, `CLAUDE.md`, or `GEMINI.md` files.

**Use Cases:**

- Multi-step development tasks
- Complex refactoring operations
- Automated code generation
- Agent-specific workflows

## Implementation Guide

### Step 1: Create Repository-Wide Instructions

1. **Create the directory structure:**

   ```bash
   mkdir -p .github
   ```

2. **Create the main instructions file:**

   ```bash
   touch .github/copilot-instructions.md
   ```

3. **Add comprehensive project context:**

   ```markdown
   # Project Overview
   
   This is a modern web application built with React and Node.js, using TypeScript throughout the stack. The application follows a microservices architecture with separate frontend and backend services.
   
   ## Technology Stack
   
   - **Frontend**: React 18, TypeScript, Tailwind CSS, Vite
   - **Backend**: Node.js, Express, TypeScript, PostgreSQL
   - **Testing**: Jest, React Testing Library, Cypress
   - **Deployment**: Docker, GitHub Actions
   
   ## Architecture
   
   - `/src`: Frontend source code
   - `/server`: Backend API services
   - `/shared`: Shared utilities and types
   - `/docs`: Project documentation
   
   ## Coding Standards
   
   - Use TypeScript strict mode
   - Follow ESLint and Prettier configurations
   - Use functional components with hooks
   - Implement proper error handling
   - Write comprehensive tests for all features
   ```

### Step 2: Create Path-Specific Instructions

1. **Create the instructions directory:**

   ```bash
   mkdir -p .github/instructions
   ```

2. **Create language-specific instructions:**

   ```bash
   # TypeScript files
   touch .github/instructions/typescript.instructions.md
   
   # React components
   touch .github/instructions/react.instructions.md
   
   # API routes
   touch .github/instructions/api.instructions.md
   ```

3. **Configure path-specific rules:**

   ```markdown
   ---
   applyTo: "**/*.ts,**/*.tsx"
   ---
   
   # TypeScript Guidelines
   
   - Always use explicit type annotations for function parameters and return types
   - Prefer interfaces over types for object shapes
   - Use strict null checks and handle undefined cases
   - Implement proper error handling with custom error classes
   - Use async/await instead of Promises for better readability
   ```

### Step 3: Create Agent Instructions

1. **Create agent instruction files:**

   ```bash
   # For general AI agents
   touch AGENTS.md
   
   # For Claude-specific instructions
   touch CLAUDE.md
   
   # For Gemini-specific instructions
   touch GEMINI.md
   ```

2. **Define agent-specific workflows:**

   ```markdown
   # Agent Instructions
   
   You are an expert software engineer working on this React/Node.js application.
   
   ## Your Role
   
   - Analyse code requirements and provide implementation plans
   - Generate code that follows project conventions
   - Suggest improvements and optimisations
   - Help with debugging and troubleshooting
   
   ## Workflow
   
   1. Always start by understanding the context and requirements
   2. Provide a clear implementation plan
   3. Generate code with proper error handling
   4. Include relevant tests and documentation
   5. Suggest follow-up improvements
   ```

## Best Practices

### Writing Effective Instructions

1. **Be Specific and Concise**
   - Provide clear, actionable guidance
   - Avoid vague or overly broad statements
   - Focus on project-specific requirements

2. **Include Project Context**
   - Describe the project's purpose and goals
   - Explain the technology stack and architecture
   - Document coding standards and conventions

3. **Provide Examples**
   - Include code examples that demonstrate best practices
   - Show both good and bad patterns
   - Reference existing code in the repository

4. **Keep Instructions Current**
   - Regularly update instructions as the project evolves
   - Remove outdated information
   - Add new patterns and conventions

### Common Pitfalls to Avoid

1. **Overly Complex Instructions**
   - Avoid instructions that are too detailed or complex
   - Keep instructions focused on essential information
   - Don't include external dependencies or references

2. **Conflicting Instructions**
   - Ensure consistency across different instruction files
   - Avoid contradictory guidance
   - Coordinate with team members on instruction updates

3. **Outdated Information**
   - Regularly review and update instructions
   - Remove references to deprecated technologies
   - Keep version numbers current

## Examples

### Complete Repository Instructions Example

```markdown
# Project: E-Commerce Platform

## Overview
A full-stack e-commerce platform built with React, Node.js, and PostgreSQL. The application handles product catalogues, user authentication, order management, and payment processing.

## Technology Stack
- **Frontend**: React 18, TypeScript, Tailwind CSS, React Query
- **Backend**: Node.js, Express, TypeScript, PostgreSQL, Prisma
- **Authentication**: JWT tokens, bcrypt
- **Payment**: Stripe integration
- **Testing**: Jest, React Testing Library, Supertest

## Project Structure
```
src/
├── components/          # Reusable UI components
├── pages/             # Page components
├── hooks/             # Custom React hooks
├── services/          # API service functions
├── types/             # TypeScript type definitions
├── utils/             # Utility functions
└── styles/            # Global styles and themes
```

## Coding Standards

### TypeScript
- Use strict mode and explicit type annotations
- Prefer interfaces over types for object shapes
- Use proper error handling with custom error classes
- Implement proper null/undefined checks

### React
- Use functional components with hooks
- Implement proper prop types and default values
- Use React.memo for performance optimisation
- Follow the single responsibility principle

### API Development
- Use RESTful API design principles
- Implement proper HTTP status codes
- Use middleware for authentication and validation
- Include comprehensive error handling

### Testing
- Write unit tests for all utility functions
- Create integration tests for API endpoints
- Use React Testing Library for component tests
- Maintain at least 80% code coverage

## Security Guidelines
- Validate all user inputs
- Use parameterised queries to prevent SQL injection
- Implement proper authentication and authorisation
- Follow OWASP security best practices

## Performance Considerations
- Implement proper caching strategies
- Use lazy loading for large components
- Optimise database queries
- Monitor and profile application performance
```

### Path-Specific Instructions Example

```markdown
---
applyTo: "src/components/**/*.tsx"
---

# React Component Guidelines

## Component Structure
- Use functional components with TypeScript
- Implement proper prop interfaces
- Use React.memo for performance optimisation
- Follow the single responsibility principle

## Styling
- Use Tailwind CSS utility classes
- Create reusable component variants
- Implement responsive design patterns
- Use CSS modules for component-specific styles

## State Management
- Use local state for component-specific data
- Implement React Query for server state
- Use context for deeply nested prop drilling
- Avoid unnecessary re-renders

## Examples
```typescript
interface ButtonProps {
  variant: 'primary' | 'secondary' | 'danger';
  size: 'sm' | 'md' | 'lg';
  onClick: () => void;
  children: React.ReactNode;
}

export const Button: React.FC<ButtonProps> = ({ 
  variant, 
  size, 
  onClick, 
  children 
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```
```

## Troubleshooting

### Common Issues

1. **Instructions Not Being Applied**
   - Verify file location and naming convention
   - Check file permissions and accessibility
   - Ensure proper Markdown syntax
   - Restart VS Code or refresh GitHub.com

2. **Conflicting Suggestions**
   - Review instruction files for contradictions
   - Ensure consistent coding standards across files
   - Update outdated instructions

3. **Performance Issues**
   - Keep instructions concise and focused
   - Avoid overly complex or lengthy instructions
   - Remove unnecessary external references

### Verification Methods

1. **Check References in Copilot Chat**
   - Look for instruction files in the References list
   - Verify that custom instructions are being applied
   - Test with specific scenarios to confirm behaviour

2. **Test Different Scenarios**
   - Try various coding tasks
   - Verify suggestions match your instructions
   - Check consistency across different file types

## Resources

### Official Documentation
- [GitHub Copilot Custom Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions)
- [Repository Custom Instructions](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions)
- [VS Code Custom Instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

### Community Resources
- [Awesome Copilot Repository](https://github.com/github/awesome-copilot)
- [Custom Instructions Examples](https://github.com/github/awesome-copilot/tree/main/instructions)
- [Best Practices Guide](https://github.com/github/awesome-copilot/tree/main/instructions)

### Related Tools
- [GitHub Copilot Chat](https://docs.github.com/en/copilot/using-github-copilot/github-copilot-chat)
- [VS Code Copilot Extension](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot)
- [GitHub Copilot CLI](https://github.com/github/gh-copilot)

---

*This guide provides comprehensive information about GitHub repository instructions. For the latest updates and features, refer to the official GitHub documentation.*
