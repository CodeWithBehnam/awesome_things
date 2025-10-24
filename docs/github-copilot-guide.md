# GitHub Copilot: Complete Guide to Instructions, Prompts, and Chat Modes

## Overview

GitHub Copilot is an AI-powered coding assistant that helps developers write code faster and more efficiently. It provides intelligent code completions, chat-based assistance, and autonomous coding capabilities across multiple IDEs and platforms.

**Key Features:**
- 🤖 **AI-powered code completions** with context-aware suggestions
- 💬 **Copilot Chat** for natural language code assistance
- 🎯 **Agent Mode** for autonomous multi-step coding tasks
- 🔧 **Edit Mode** for controlled code modifications
- 🌐 **Multi-platform support** across VS Code, Visual Studio, JetBrains, Xcode, and Eclipse
- 🎨 **Custom instructions** and prompt files for personalized assistance
- 🔗 **Extension ecosystem** with third-party integrations

## Prerequisites

- **GitHub account** with Copilot access (Individual, Business, or Enterprise)
- **Compatible IDE** (VS Code, Visual Studio, JetBrains, Xcode, or Eclipse)
- **Latest version** of the GitHub Copilot extension
- **Internet connection** for AI model access

## Installation and Setup

### VS Code Installation

1. **Install the Extension:**
   ```bash
   # Via VS Code Marketplace
   code --install-extension GitHub.copilot
   ```

2. **Sign in to GitHub:**
   - Open VS Code
   - Click the Copilot icon in the status bar
   - Follow the authentication flow

3. **Verify Installation:**
   - Look for the Copilot icon in the status bar
   - Check that inline suggestions appear as you type

### Other IDEs

**Visual Studio:**
- Install via Visual Studio Marketplace
- Built-in for Visual Studio 17.10+

**JetBrains IDEs:**
- Install from JetBrains Marketplace
- Compatible with IntelliJ IDEA, PyCharm, WebStorm, etc.

**Xcode:**
- Install from Xcode Extensions
- Available for macOS development

**Eclipse:**
- Install from Eclipse Marketplace
- Requires Eclipse 2024-09 or later

## Core Features

### 1. Inline Code Completions

GitHub Copilot provides intelligent code suggestions as you type:

```python
# Start typing a function
def calculate_fibonacci(n):
    # Copilot suggests the implementation
    if n <= 1:
        return n
    return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)
```

**Best Practices for Inline Completions:**
- **Provide context** with meaningful function names and comments
- **Open relevant files** to give Copilot more context
- **Use descriptive variable names** for better suggestions
- **Include imports** at the top of files

### 2. Copilot Chat

Access Copilot Chat for natural language assistance:

**Opening Chat:**
- **VS Code:** Click the Copilot icon in the title bar
- **Visual Studio:** View → GitHub Copilot Chat
- **JetBrains:** Click the Copilot Chat icon in the activity bar
- **Xcode:** Editor → GitHub Copilot → Open Chat

**Chat Features:**
- **Natural language prompts** for code generation
- **Code explanation** and documentation
- **Debugging assistance** and error fixing
- **Test generation** and code review

### 3. Chat Modes

#### **Edit Mode**
For controlled, granular code changes:

```markdown
# Use Edit Mode for:
- Quick, specific updates to defined files
- Full control over LLM requests
- Step-by-step code modifications
- Reviewing changes before applying
```

**How to Use Edit Mode:**
1. Open Copilot Chat
2. Select **Edit** from the mode dropdown
3. Add files to the working set
4. Submit your prompt
5. Review and apply/discard changes for each file

#### **Agent Mode**
For autonomous, multi-step coding tasks:

```markdown
# Use Agent Mode for:
- Complex tasks with multiple steps
- Autonomous code generation
- Integration with external tools
- Error handling and iteration
```

**How to Use Agent Mode:**
1. Open Copilot Chat
2. Select **Agent** from the mode dropdown
3. Submit your task prompt
4. Review streaming edits and terminal commands
5. Confirm or deny suggested actions

### 4. Chat Participants

Use `@` to access specialized chat participants:

**Built-in Participants:**
- `@workspace` - Reference entire workspace
- `@project` - Reference current project
- `@github` - GitHub-specific skills and web search
- `@terminal` - Terminal and command assistance

**Custom Extensions:**
- Install from GitHub Marketplace
- Install from IDE-specific marketplaces
- Build private extensions for organizations

### 5. Slash Commands

Use `/` for quick access to common functions:

**Available Commands:**
- `/explain` - Explain selected code
- `/fix` - Fix errors in code
- `/tests` - Generate unit tests
- `/docs` - Generate documentation
- `/refactor` - Refactor code
- `/review` - Code review

### 6. Chat Variables

Use `#` to include specific context:

**Available Variables:**
- `#file` - Reference specific file
- `#selection` - Reference selected code
- `#workspace` - Reference workspace
- `#web` - Enable web search

## Prompt Engineering Best Practices

### 1. Start General, Then Get Specific

**Good Prompt Structure:**
```
Write a JavaScript function that tells me if a number is prime

The function should take an integer and return true if the integer is prime
The function should error if the input is not a positive integer
```

**Benefits:**
- Provides clear context
- Specifies requirements
- Sets expectations

### 2. Give Examples

**Use Examples for Clarity:**
```
Write a Go function that finds all dates in a string and returns them in an array. Dates can be formatted like:

* 05/02/24
* 05/02/2024
* 5/2/24
* 5/2/2024
* 05-02-24
* 05-02-2024
* 5-2-24
* 5-2-2024

Example:
findDates("I have a dentist appointment on 11/14/2023 and book club on 12-1-23")
Returns: ["11/14/2023", "12-1-23"]
```

### 3. Break Complex Tasks into Simpler Tasks

**Instead of:**
```
Generate a word search puzzle
```

**Break it down:**
```
1. Write a function to generate a 10 by 10 grid of letters
2. Write a function to find all words in a grid of letters
3. Write a function that uses the previous functions to generate a grid
4. Update the function to print the grid and random words
```

### 4. Avoid Ambiguity

**Bad:**
```
What does this do?
```

**Good:**
```
What does the createUser function do?
What does the code in your last response do?
```

### 5. Provide Context

**File Context:**
- Open relevant files
- Close irrelevant files
- Use meaningful function names
- Include proper imports

**Code Context:**
```python
# Good context
import requests
from typing import List, Dict

def fetch_user_data(user_id: int) -> Dict:
    """
    Fetch user data from API
    """
    # Copilot has context about the function purpose
```

### 6. Use Keywords and Variables

**Chat Participants:**
```
@github Search the web to find the latest GPT model from OpenAI
@workspace Explain the authentication flow in this project
```

**Slash Commands:**
```
/explain this authentication function
/fix the error in the login method
/tests generate unit tests for the UserService class
```

**Chat Variables:**
```
@github #web What is the latest LTS of Node.js?
#file src/auth.js Explain this file
#selection How can I optimize this code?
```

## Advanced Features

### 1. Custom Instructions

Create custom instructions for consistent responses:

**File: `.copilot/instructions.md`**
```markdown
# Custom Instructions

## Code Style
- Use TypeScript for all new code
- Follow ESLint configuration
- Use functional programming patterns
- Include JSDoc comments

## Testing
- Write unit tests for all functions
- Use Jest testing framework
- Aim for 90% code coverage
- Include integration tests

## Security
- Validate all inputs
- Use parameterized queries
- Implement proper error handling
- Follow OWASP guidelines
```

### 2. Prompt Files

Create reusable prompts for common tasks:

**File: `.copilot/prompts/review-code.md`**
```markdown
# Code Review Prompt

Please review the following code and provide feedback on:

1. **Code Quality**
   - Readability and maintainability
   - Performance considerations
   - Error handling

2. **Security**
   - Input validation
   - Authentication and authorization
   - Data protection

3. **Best Practices**
   - Design patterns
   - Code organization
   - Documentation

4. **Suggestions**
   - Improvements
   - Refactoring opportunities
   - Additional tests needed
```

### 3. Image Support

Attach images to chat prompts:

**Supported Formats:**
- JPEG (`.jpg`, `.jpeg`)
- PNG (`.png`)
- GIF (`.gif`)
- WEBP (`.webp`)

**Use Cases:**
- Screenshots of code snippets
- UI mockups for code generation
- Flowcharts for process description
- Error screenshots for debugging

### 4. AI Model Selection

Choose different AI models for different tasks:

**Available Models:**
- **Included Model** - Free, general-purpose
- **Premium Models** - Advanced capabilities, specialized tasks
- **GPT-4** - Complex reasoning and analysis
- **Claude** - Code generation and explanation

**Model Selection Tips:**
- Use premium models for complex tasks
- Switch models based on task requirements
- Consider cost implications
- Test different models for your use cases

## IDE-Specific Features

### VS Code

**Quick Access:**
- **Quick Chat:** `Shift+Option+Cmd+L` (Mac) / `Ctrl+Shift+Alt+L` (Windows/Linux)
- **Inline Chat:** `Cmd+I` (Mac) / `Ctrl+I` (Windows/Linux)
- **Smart Actions:** Right-click → Copilot → Select action

**Chat Participants:**
- `@workspace` - Reference entire workspace
- `@project` - Reference current project
- `@github` - GitHub skills and web search

### Visual Studio

**Access Methods:**
- **Menu:** View → GitHub Copilot Chat
- **Inline:** Right-click → Ask Copilot
- **Built-in:** Available in Visual Studio 17.10+

**Features:**
- **References:** Use `#` for file references
- **Extensions:** Install from GitHub Marketplace
- **Slash Commands:** Type `/` for available commands

### JetBrains IDEs

**Access:**
- **Chat Icon:** Click in the activity bar
- **Inline:** Right-click → GitHub Copilot → Inline Chat
- **Shortcut:** `Ctrl+Shift+I` for inline chat

**Features:**
- **File References:** Drag files into chat
- **Built-in Requests:** Right-click → GitHub Copilot
- **Working Set:** Add files to working set for edits

### Xcode

**Access:**
- **Menu:** Editor → GitHub Copilot → Open Chat
- **Agent Mode:** Available for autonomous tasks
- **File References:** Click paperclip icon

**Features:**
- **Conversation Threads:** Organize discussions
- **Chat History:** Revisit previous conversations
- **File Attachments:** Use paperclip icon

### Eclipse

**Access:**
- **Status Bar:** Click Copilot icon → Open Chat
- **Slash Commands:** Type `/` for available commands
- **Agent Mode:** Available for complex tasks

**Features:**
- **File References:** Use `#` for specific files
- **Working Set:** Add files for edit mode
- **Terminal Integration:** Run suggested commands

## Best Practices

### 1. Code Quality

**Follow Good Coding Practices:**
- Use consistent code style
- Write descriptive names
- Comment your code
- Structure code modularly
- Include unit tests

**Example:**
```python
# Good: Clear, well-documented code
def calculate_user_score(user_id: int, activity_data: Dict) -> float:
    """
    Calculate user engagement score based on activity data.
    
    Args:
        user_id: Unique identifier for the user
        activity_data: Dictionary containing user activity metrics
        
    Returns:
        Float representing the user's engagement score
    """
    # Implementation here
```

### 2. Context Management

**Provide Relevant Context:**
- Open related files
- Use meaningful function names
- Include proper imports
- Add descriptive comments

**Example:**
```javascript
// Good context for Copilot
import { UserService } from './services/UserService';
import { validateEmail } from './utils/validation';

/**
 * Creates a new user account with validation
 */
async function createUserAccount(userData) {
    // Copilot understands the context and purpose
}
```

### 3. Iterative Development

**Start Simple, Then Refine:**
1. **Initial Prompt:** Basic functionality
2. **Refinement:** Add specific requirements
3. **Optimization:** Improve performance
4. **Testing:** Add comprehensive tests

**Example Workflow:**
```
1. "Write a function to validate email addresses"
2. "Add support for international email formats"
3. "Optimize for performance with large datasets"
4. "Add comprehensive unit tests"
```

### 4. Error Handling

**Use Copilot for Debugging:**
- **Error Analysis:** "Explain this error message"
- **Code Review:** "Review this code for potential issues"
- **Fix Suggestions:** "Fix the bug in this function"
- **Testing:** "Generate tests for this edge case"

### 5. Documentation

**Generate Documentation:**
- **Code Comments:** "Add JSDoc comments to this function"
- **README Files:** "Create a README for this project"
- **API Documentation:** "Generate API documentation"
- **User Guides:** "Create a user guide for this feature"

## Troubleshooting

### Common Issues

**1. Authentication Problems**
```bash
# VS Code
# Sign out and sign back in
# Check GitHub account permissions
# Verify Copilot subscription status
```

**2. No Suggestions Appearing**
- Check internet connection
- Verify Copilot extension is enabled
- Restart IDE
- Check for extension updates

**3. Poor Quality Suggestions**
- Provide more context
- Use descriptive function names
- Open relevant files
- Add meaningful comments

**4. Chat Not Working**
- Check organization policies
- Verify chat is enabled
- Update to latest extension version
- Check authentication status

### Performance Optimization

**1. Context Management**
- Close unnecessary files
- Use specific file references
- Clear chat history when needed
- Use focused prompts

**2. Model Selection**
- Use appropriate model for task
- Consider cost vs. quality trade-offs
- Test different models
- Monitor usage and costs

**3. Prompt Optimization**
- Be specific and clear
- Provide examples
- Break down complex tasks
- Use appropriate keywords

## Advanced Use Cases

### 1. Code Generation

**Generate Complete Applications:**
```
Create a REST API with the following endpoints:
- GET /users - List all users
- POST /users - Create new user
- PUT /users/:id - Update user
- DELETE /users/:id - Delete user

Use Express.js, include validation, error handling, and tests.
```

### 2. Code Refactoring

**Modernize Legacy Code:**
```
Refactor this JavaScript code to use modern ES6+ features:
- Convert to arrow functions where appropriate
- Use destructuring and spread operators
- Implement async/await instead of callbacks
- Add TypeScript type annotations
```

### 3. Testing

**Generate Comprehensive Tests:**
```
Write unit tests for this authentication service:
- Test successful login
- Test invalid credentials
- Test account lockout
- Test password reset
- Test edge cases and error conditions
```

### 4. Documentation

**Create Technical Documentation:**
```
Generate API documentation for this Express.js application:
- Include endpoint descriptions
- Add request/response examples
- Document authentication requirements
- Include error codes and messages
```

### 5. Debugging

**Debug Complex Issues:**
```
Debug this performance issue in the user service:
- Analyze the code for bottlenecks
- Identify potential memory leaks
- Suggest optimization strategies
- Provide monitoring recommendations
```

## Integration with Development Workflow

### 1. Version Control

**Git Integration:**
- Use Copilot for commit messages
- Generate pull request descriptions
- Review code changes
- Suggest improvements

### 2. CI/CD

**Automation:**
- Generate deployment scripts
- Create configuration files
- Write monitoring code
- Develop testing pipelines

### 3. Code Review

**Review Process:**
- Use Copilot for code analysis
- Generate review comments
- Suggest improvements
- Check for security issues

### 4. Documentation

**Documentation Generation:**
- Create README files
- Generate API docs
- Write user guides
- Develop tutorials

## Security Considerations

### 1. Code Security

**Security Best Practices:**
- Validate all inputs
- Use parameterized queries
- Implement proper authentication
- Follow OWASP guidelines

### 2. Data Privacy

**Privacy Protection:**
- Don't share sensitive data
- Use placeholder data in examples
- Be cautious with personal information
- Follow company policies

### 3. Access Control

**Access Management:**
- Use appropriate permissions
- Monitor usage and costs
- Implement team policies
- Regular security reviews

## Cost Management

### 1. Usage Monitoring

**Track Usage:**
- Monitor premium requests
- Set usage limits
- Review monthly costs
- Optimize model selection

### 2. Cost Optimization

**Reduce Costs:**
- Use included model when possible
- Optimize prompt length
- Batch similar requests
- Use appropriate models for tasks

### 3. Team Management

**Organization Policies:**
- Set usage limits
- Monitor team usage
- Implement cost controls
- Regular cost reviews

## Resources

### Official Documentation
- **GitHub Copilot Docs**: [https://docs.github.com/en/copilot](https://docs.github.com/en/copilot)
- **VS Code Copilot**: [https://code.visualstudio.com/docs/copilot](https://code.visualstudio.com/docs/copilot)
- **Visual Studio Copilot**: [https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-chat](https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-chat)

### Community Resources
- **GitHub Copilot FAQ**: [https://github.com/features/copilot#faq](https://github.com/features/copilot#faq)
- **Copilot Trust Center**: [https://copilot.github.trust.page](https://copilot.github.trust.page)
- **Awesome Copilot**: [https://github.com/github/awesome-copilot](https://github.com/github/awesome-copilot)

### Learning Resources
- **Prompt Engineering Guide**: [https://docs.github.com/en/copilot/using-github-copilot/copilot-chat/prompt-engineering-for-copilot-chat](https://docs.github.com/en/copilot/using-github-copilot/copilot-chat/prompt-engineering-for-copilot-chat)
- **Best Practices**: [https://docs.github.com/en/copilot/get-started/best-practices](https://docs.github.com/en/copilot/get-started/best-practices)
- **Chat Cheat Sheet**: [https://docs.github.com/en/copilot/using-github-copilot/github-copilot-chat-cheat-sheet](https://docs.github.com/en/copilot/using-github-copilot/github-copilot-chat-cheat-sheet)

## Conclusion

GitHub Copilot represents a significant advancement in AI-assisted development, offering powerful tools for code generation, explanation, and automation. By following best practices for prompt engineering, understanding the different chat modes, and leveraging the extensive customization options, developers can significantly enhance their productivity and code quality.

**Key Takeaways:**
- **Start with clear, specific prompts** for better results
- **Use appropriate chat modes** for different tasks
- **Leverage custom instructions** for consistent responses
- **Follow security best practices** when using AI assistance
- **Monitor usage and costs** to optimize value
- **Integrate with development workflow** for maximum benefit

GitHub Copilot is not just a code completion tool—it's a comprehensive AI assistant that can transform how you approach software development, from initial concept to deployment and maintenance.
