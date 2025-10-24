# Generate Documentation Command

Automatically research and generate comprehensive documentation using Ref MCP and Exa MCP tools.

## Documentation Generation Process

When I use this command, follow these steps:

1. **Research Phase**
   - Use `ref_search_documentation` to search for official documentation and resources
   - Use `ref_read_url` to read full content from documentation URLs
   - Use `web_search_exa` for general web search with content extraction
   - Use `get_code_context_exa` to find code examples and implementation details
   - Gather comprehensive information from multiple sources

2. **Analysis Phase**
   - Analyze the research results for accuracy and relevance
   - Identify key concepts, best practices, and examples
   - Organize information into logical sections

3. **Documentation Creation**
   - Create well-structured markdown documentation
   - Include clear explanations and examples
   - Add practical usage instructions
   - Include relevant code snippets and configurations
   - Provide links to additional resources

4. **Quality Assurance**
   - Ensure documentation is comprehensive and accurate
   - Verify all examples are working and up-to-date
   - Check for completeness and clarity
   - Add proper formatting and structure

## Documentation Structure

Create documentation with:
- **Overview** - Clear introduction and purpose
- **Prerequisites** - Requirements and setup
- **Step-by-step instructions** - Detailed implementation guide
- **Examples** - Practical code examples
- **Best practices** - Recommended approaches
- **Troubleshooting** - Common issues and solutions
- **Resources** - Links to additional information

## Output Requirements

- Save documentation to appropriate location (usually `docs/` folder)
- Use clear, professional language
- Include code examples with proper syntax highlighting
- Add table of contents for longer documents
- Ensure all links are valid and accessible
- Follow markdown best practices

## Available MCP Tools

### Ref MCP Tools
- **`ref_search_documentation`** - Search across indexed documentation resources
  - Parameters: `query` (string) - Include programming language, framework, or library names
  - Best for: Official documentation, API references, framework guides

- **`ref_read_url`** - Read full content of documentation URLs
  - Parameters: `url` (string) - Exact URL from search results or any web URL
  - Best for: Detailed documentation pages, specific guides, tutorials

### Exa MCP Tools
- **`web_search_exa`** - General web search with content extraction
  - Parameters: `query` (string), `numResults` (number, default: 5)
  - Best for: Current information, recent examples, real-time data

- **`get_code_context_exa`** - Find code examples and implementation details
  - Parameters: `query` (string), `tokensNum` (number or "dynamic")
  - Best for: Code examples, implementation patterns, technical context

- **`research_paper_search`** - Academic papers and research content
- **`company_research`** - Company analysis and business intelligence
- **`crawling`** - Extract content from specific URLs
- **`competitor_finder`** - Find business competitors
- **`linkedin_search`** - Search LinkedIn profiles and companies
- **`wikipedia_search_exa`** - Wikipedia content retrieval
- **`github_search`** - Repository and code search

## Research Guidelines

- **Start with Ref MCP** for official documentation and authoritative sources
- **Use Exa MCP** for current examples, real-time information, and code context
- **Combine multiple tools** for comprehensive coverage
- **Verify information accuracy** across different sources
- **Focus on practical, actionable content**
- **Include both beginner and advanced topics** when relevant
- **Prioritize recent and up-to-date information**
