# Hierarchical Context Organization

**Principle:** Structure context in layers from general (system-level) to specific (task-level), allowing models to prioritize relevant information naturally.

## Why

Models process context sequentially. Placing broad instructions first and specific details later mirrors how humans read documents — from overview to detail. This reduces ambiguity and helps the model frame specific information within the right mental model.

## How to Apply

Layer context in this order:
1. **System context** — Role, capabilities, global constraints
2. **Domain context** — Project-specific knowledge, conventions, architecture
3. **Task context** — The specific instruction or question
4. **Input data** — The actual content to process

## Example

```
# System (layer 1)
You are a code reviewer for a production TypeScript codebase.

# Domain (layer 2)
This project uses NestJS with a hexagonal architecture.
Domain logic lives in src/domain/, adapters in src/adapters/.
We enforce strict null checks and prefer Result types over exceptions.

# Task (layer 3)
Review the following diff for architectural violations and type safety issues.

# Input (layer 4)
<diff>...</diff>
```

Compare with flat, unstructured context where all of this is jumbled in a single paragraph — the model must work harder to separate instructions from data.

## Sources

- [Context Engineering 2.0](https://arxiv.org/pdf/2510.26493) — "Structure context in layers from general (system-level) to specific (task-level)"
