# Invest in Tool Design (Agent-Computer Interface)

**Principle:** Tool descriptions deserve as much design effort as user interfaces. Poka-yoke your tools — make misuse structurally difficult.

## Why

When an agent calls a tool, the tool description *is* the context the model uses to decide how and when to invoke it. Vague or incomplete tool descriptions cause wrong tool selection, malformed arguments, and wasted iterations.

## How to Apply

- Write tool descriptions like API docs: include purpose, parameters, examples, edge cases.
- Make invalid states unrepresentable in tool parameters (e.g., require absolute paths instead of allowing relative ones).
- Test tools with actual model usage, not just human review.
- Draw clear boundaries between similar tools so the model knows which to pick.

## Example

Bad tool description:
```json
{
  "name": "search",
  "description": "Searches for things",
  "parameters": { "q": { "type": "string" } }
}
```

Good tool description:
```json
{
  "name": "search_codebase",
  "description": "Search for code patterns across the repository using regex. Returns matching file paths and line numbers. Use this for finding function definitions, imports, or usage patterns. For finding files by name, use `find_files` instead.",
  "parameters": {
    "pattern": {
      "type": "string",
      "description": "Regex pattern to search for (e.g., 'def process_.*payment')"
    },
    "file_type": {
      "type": "string",
      "description": "Limit search to file type: 'py', 'ts', 'go', etc. Omit to search all files."
    },
    "max_results": {
      "type": "integer",
      "description": "Maximum results to return (default: 20). Use lower values for broad patterns.",
      "default": 20
    }
  }
}
```

## Sources

- [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) — "Invest just as much effort in creating good agent-computer interfaces (ACI)"
- [Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents) — "Poka-yoke your tools by redesigning arguments to make mistakes harder"
