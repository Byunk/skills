---
name: context-engineering
description: |
  Principles for designing context-efficient AI agents and tools.
  Use when designing LLM tools, agents, MCP servers, or multi-agent systems.
allowed-tools:
  - Read
  - Glob
  - Grep
---

# Context Engineering

Principles and patterns for strategically designing the information provided to LLMs.
Context is a critical but finite resource — these principles help you use it well.

## References

| # | Principle | File | Summary |
|---|-----------|------|---------|
| 1 | [Quality Over Quantity](references/01-quality-over-quantity.md) | `01-quality-over-quantity.md` | Include only relevant context. Precision beats exhaustiveness. |
| 2 | [Start Minimal, Layer Progressively](references/02-start-minimal.md) | `02-start-minimal.md` | Begin with essentials, expand based on performance gaps. |
| 3 | [Hierarchical Context Organization](references/03-hierarchical-organization.md) | `03-hierarchical-organization.md` | Structure context from general to specific. Use XML tags for disambiguation. |
| 4 | [Multi-Dimensional Context](references/04-multi-dimensional-context.md) | `04-multi-dimensional-context.md` | Effective context spans task, domain, history, constraints, motivation, and format. |
| 5 | [Simple Composable Patterns](references/05-simple-composable-patterns.md) | `05-simple-composable-patterns.md` | Prefer prompt chaining, routing, parallelization over complex frameworks. |
| 6 | [Invest in Tool Design (ACI)](references/06-invest-in-tool-design.md) | `06-invest-in-tool-design.md` | Tool descriptions deserve as much effort as UIs. Calibrate action language for Claude 4.6. |
| 7 | [Match Architecture to Complexity](references/07-match-architecture-to-complexity.md) | `07-match-architecture-to-complexity.md` | Choose the right pattern: chaining, routing, parallelization, orchestrator, or agent. |
| 8 | [Transparency in Agent Planning](references/08-transparency-in-planning.md) | `08-transparency-in-planning.md` | Show planning steps. Use structured state tracking for long-horizon tasks. |
| 9 | [Contextualize Retrieved Chunks](references/09-contextualize-retrieved-chunks.md) | `09-contextualize-retrieved-chunks.md` | Prepend explanatory context before embedding. Reduces retrieval failures by 35-67%. |
| 10 | [Dynamic Context Adaptation](references/10-dynamic-context-adaptation.md) | `10-dynamic-context-adaptation.md` | Adjust context based on task complexity and model confidence. |
| 11 | [Meta-Context](references/11-meta-context.md) | `11-meta-context.md` | Explain why information is provided. Use grounding directives to reduce hallucinations. |
| 12 | [Ground Agents in Environment Feedback](references/12-ground-in-environment.md) | `12-ground-in-environment.md` | Use tool results and human checkpoints, not just model reasoning. |
| 13 | [Test and Measure Systematically](references/13-test-and-measure.md) | `13-test-and-measure.md` | A/B test context variations. Measure accuracy, latency, reasoning quality. |
| 14 | [Retrieve Generously, Filter Late](references/14-retrieve-generously.md) | `14-retrieve-generously.md` | Top-20 chunks outperform top-5. Don't over-filter prematurely. |
| 15 | [Avoid Common Anti-Patterns](references/15-anti-patterns.md) | `15-anti-patterns.md` | Don't dump everything, over-abstract, overengineer, or inherit stale aggressive prompts. |
| 16 | [Guide Model Thinking](references/16-guide-model-thinking.md) | `16-guide-model-thinking.md` | Control reasoning depth with adaptive thinking. Prevent overthinking on simple tasks. |
| 17 | [Multi-Window State Management](references/17-multi-window-state.md) | `17-multi-window-state.md` | Externalize state for tasks spanning multiple context windows. |
| 18 | [Calibrate Autonomy and Safety](references/18-calibrate-autonomy.md) | `18-calibrate-autonomy.md` | Tune action thresholds. Claude 4.6 defaults to high autonomy; set guardrails. |
