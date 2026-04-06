# Skills

Claude Code harness.

## Installation

1. Open Claude Code
2. `/plugin`
3. Marketplaces > Add Marketplace
4. Enter https://github.com/Byunk/skills
5. Install skills

Alternatively,

```bash
claude plugin marketplace add https://github.com/Byunk/skills
claude plugin install <skill-name>@skills
```

## Available Skills

| Skill | Description | Usage |
|-------|-------------|-------|
| `code-review` | Single-pass code review focused on clean code and OOP principles with auto mode detection | `/code-review` |
| `context-engineering` | Principles for designing context-efficient AI agents and tools | `/context-engineering` |
| `create-pr` | Create a GitHub PR with convention-aware title, concise summary, and review guide | `/create-pr` |
| `notify` | Native OS notifications when Claude Code needs your attention (permission requests, task completion) | Auto-triggers on `PermissionRequest` and `Stop` events |

## License

MIT
