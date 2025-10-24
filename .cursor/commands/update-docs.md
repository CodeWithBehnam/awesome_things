# Update Documentation Command

Automatically research and update existing documentation using Ref MCP and Exa MCP tools.

## Documentation Update Process

When I use this command, follow these steps:

1. **Research Phase**
   - Use `ref_search_documentation` to search for latest official documentation and resources
   - Use `ref_read_url` to read updated content from documentation URLs
   - Use `web_search_exa` for recent changes, updates, and new features
   - Use `get_code_context_exa` to find updated code examples and implementation details
   - Gather comprehensive information about changes and improvements

2. **Analysis Phase**
   - Compare new information with existing documentation
   - Identify outdated sections, deprecated features, and new additions
   - Analyze changes in best practices and recommendations
   - Organize updates into logical sections

3. **Documentation Update**
   - Update existing markdown documentation with new information
   - Revise outdated examples and code snippets
   - Add new sections for recent features or changes
   - Update version numbers, compatibility information, and requirements
   - Maintain consistent formatting and structure

4. **Quality Assurance**
   - Verify all updated examples are working and current
   - Check for accuracy of new information
   - Ensure consistency with existing documentation style
   - Validate all links and references are still accessible
   - Update table of contents if needed

## Update Structure

Update documentation with:
- **Version Information** - Update version numbers and compatibility
- **New Features** - Add sections for recent additions
- **Deprecated Content** - Mark outdated information clearly
- **Updated Examples** - Revise code examples with current best practices
- **Changed Requirements** - Update prerequisites and dependencies
- **New Resources** - Add links to updated documentation
- **Migration Notes** - Include guidance for users upgrading

## Output Requirements

- Update existing documentation files in place
- Maintain original file structure and formatting
- Use clear, professional language for updates
- Include code examples with proper syntax highlighting
- Add "Last Updated" timestamps where appropriate
- Ensure all links are valid and accessible
- Follow markdown best practices

## Available MCP Tools

### Ref MCP Tools
- **`ref_search_documentation`** - Search for latest official documentation
  - Parameters: `query` (string) - Include programming language, framework, or library names
  - Best for: Official documentation updates, API changes, framework guides

- **`ref_read_url`** - Read updated content from documentation URLs
  - Parameters: `url` (string) - Exact URL from search results or any web URL
  - Best for: Updated documentation pages, changelogs, migration guides

### Exa MCP Tools
- **`web_search_exa`** - Search for recent changes and updates
  - Parameters: `query` (string), `numResults` (number, default: 5)
  - Best for: Recent updates, new features, breaking changes

- **`get_code_context_exa`** - Find updated code examples and patterns
  - Parameters: `query` (string), `tokensNum` (number or "dynamic")
  - Best for: Updated code examples, new implementation patterns

- **`research_paper_search`** - Academic papers with recent findings
- **`company_research`** - Company updates and product changes
- **`crawling`** - Extract content from updated URLs
- **`github_search`** - Repository updates and new releases

## Update Guidelines

- **Start with Ref MCP** for official documentation updates
- **Use Exa MCP** for recent changes, new features, and community updates
- **Compare versions** to identify what has changed
- **Preserve existing structure** while adding new content
- **Mark deprecated content** clearly with warnings
- **Update examples** to reflect current best practices
- **Include migration paths** for breaking changes
- **Verify all information** is accurate and current
