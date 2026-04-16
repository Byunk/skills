---
name: explain
description: |
  Semantic code explanation that prioritizes why over what.
  Explains purpose, design decisions, and broader context of any code target.
  Accepts natural language: a file path, symbol name, line reference, directory, or question.
  Use when asked to "explain", "what does this do", "why is this here", or "walk me through".
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
model: Sonnet
context: fork
agent: Explore
---

# Explain

Semantic code explanation. Prioritize *why it exists* and *how it fits* over line-by-line description.

---

## Step 1: Locate the Target

Use `$ARGUMENTS` (natural language) to find the code the user is asking about.

- Use Grep and Glob to search for files, symbols, classes, or functions mentioned in the arguments.
- For symbol names, search for definitions first (`class X`, `function X`, `def X`, `interface X`, `type X`).
- If the argument is a file path or `file:line`, read it directly.
- If nothing is found, report to user and stop.

---

## Step 2: Read the Target

Read the code under examination.

- For a specific line or function: read the file with surrounding context (±50 lines).
- For a file: read the full file (first 100 lines + definition scan if >500 lines).
- For a directory or module: list files, read key entry points and exports.

---

## Step 3: Gather Context

This is the critical step. Collect surrounding context that makes semantic explanation possible. Keep effort proportional to scope — don't read the entire codebase for a single function.

1. **Project-level context**: Read `README.md`, `CLAUDE.md`, or build config (`package.json`, `pyproject.toml`, etc.) to understand the project's purpose.
2. **Module-level context**: Read sibling files or barrel/index files to understand the module's role.
3. **Callers and consumers**: Grep for imports or references to the target. Read 2-3 representative callers to understand how this code is used.
4. **Git history**: Run `git log --oneline -10 -- <file>` to see why the code was introduced or changed. For specific lines, use `git log -3 -L <start>,<end>:<file>`.
5. **Related types and interfaces**: If the target implements an interface, extends a base class, or uses key types, read those definitions.

If git history is uninformative (single commit, no meaningful messages), skip it and rely on code structure.

---

## Step 4: Output

Produce a concise, layered explanation. Every section should be brief — a few sentences, not paragraphs.

```
## <Target Name>

**In one sentence:** <what this is for, in plain language>

### Context
<Where it fits in the system. What depends on it and what it depends on.>

### Why it exists
<The problem it solves. Design decisions. What motivated it (from git history if available).>

### How it works
<Key mechanism or approach — not a line-by-line walkthrough.>

### Related code
- `path/to/file.ext` — <why to look at this next>
- `SymbolName` — <relationship>
```

Rules:
- Do NOT produce line-by-line code walkthroughs.
- Do NOT enumerate every function or class mechanically.
- Mention motivating commits or bugs from git history when found.
- Adapt depth to scope: a single function gets a shorter answer than a module or codebase.
- For codebase-level questions, "Why it exists" becomes project motivation and "How it works" becomes architecture overview.
