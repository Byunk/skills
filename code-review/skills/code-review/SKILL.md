---
name: code-review
description: |
  Single-pass code review focused on clean code principles and OOP best practices.
  Auto-detects mode: PR number in arguments triggers PR mode (reads existing comments),
  uncommitted changes trigger local mode, feature branch triggers branch mode.
  Use when asked to "review code", "code review", "review my changes", or "review PR #N".
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
model: Sonnet
context: fork
agent: Explore
---

# Code Review

Single-pass, read-only code review. Report findings — do not fix code.

---

## Step 0: Detect Mode

```bash
detect-mode.sh "$ARGUMENTS"
```

- If `MODE` is empty: output **"Nothing to review — no local changes, no commits ahead of base branch."** and stop.
- Print: `Reviewing in <mode> mode`.

---

## Step 1: Gather Diff and Context

Get the diff based on the detected mode:
- **Local**: staged + unstaged changes
- **Branch**: diff against `origin/<base>`
- **PR**: `gh pr diff`, PR description, and existing review comments via `gh api`

For PR mode, read all existing review comments (inline and top-level). **Do not re-raise issues already discussed.**

Keep this step lightweight — just collect the raw diff and PR context. Do not over-analyze here.

---

## Step 2: Understand the Project

Before reviewing, build context about the codebase. This is critical for calibrating findings.

1. **Project structure**: Scan directory layout, build files (`package.json`, `pyproject.toml`, `pom.xml`, `Cargo.toml`, etc.) to understand the project type and tech stack.
2. **Conventions**: Read a few existing files in the same directories as the changed files. Note the project's naming style, error handling patterns, abstraction patterns, and file organization.
3. **Change background**: Read commit messages (`git log --oneline` for branch mode) or PR description to understand the *intent* behind the changes — what problem is being solved and why.

Use this context to distinguish intentional patterns from actual issues. Do not flag code that follows the project's established conventions.

---

## Step 3: Read Changed Files

List changed files using the mode-appropriate command. For each changed file:
- Read the **full file** (needed to assess abstraction levels and class responsibilities)
- For files exceeding 500 lines, read changed regions with 50 lines of context

---

## Step 4: Review

Evaluate the changed code at the appropriate abstraction level for the change:
- **New module/class**: Focus on overall design — responsibility, abstraction, interfaces
- **New function/method**: Focus on SLA, naming, length, error handling
- **Modification to existing code**: Focus on consistency with surrounding code, correctness, no regressions
- **Refactoring**: Focus on whether the refactoring achieves its goal without changing behavior

Only report actual problems. Do not comment on code that is fine. Be practical, not academic.

### What to look for

**Clean Code (all languages):**
- Functions mixing abstraction levels (high-level orchestration interleaved with low-level detail)
- Functions doing more than one thing or exceeding ~20 lines
- Vague or misleading names
- Non-trivial code duplication (3+ lines, 2+ occurrences)
- Swallowed exceptions, missing error paths, inconsistent error handling
- Over-abstraction or unnecessary complexity

**OOP (only when class-based patterns are used):**
- Classes with multiple unrelated responsibilities (SRP)
- Growing if/else or switch chains that should use polymorphism (OCP)
- Subclasses breaking parent contracts (LSP)
- Fat interfaces forcing unused implementations (ISP)
- Concrete dependencies where abstractions would decouple (DIP)

**Practical:**
- Layer violations (e.g., DB queries in controllers, business logic in views)
- Unexplained magic values that should be named constants
- Dead code: commented-out blocks, unreachable branches, unused imports

---

## Step 5: Output

### Findings

Classify each finding by severity:

**Critical** — Will or may cause crashes, data loss, security vulnerabilities, or incorrect behavior at runtime.

**Major** — Design flaws, likely bugs, architectural violations, or patterns that will cause maintainability problems. Includes things that look like mistakes.

**Minor** — Convention inconsistencies, style issues, naming nitpicks, or small improvements.

Number each finding sequentially starting from 1. Format each finding as:

```
### #N <severity>: one-line title

**File:** `path/to/file.ext:line`
**Code:** `quoted code from the diff`
**Why it matters:** One sentence explaining the impact.
**Suggestion:** Concrete fix or direction.
```

Example:

```
### #1 Critical: Unhandled null reference in user lookup

**File:** `src/services/UserService.ts:42`
**Code:** `const email = user.profile.email`
**Why it matters:** `user.profile` can be null when the account is pending, causing a runtime crash.
**Suggestion:** Add null check: `const email = user.profile?.email ?? ''`
```

### Ordering

List findings in this order: Critical first, then Major, then Minor.

### PR mode: Existing Discussion

When in PR mode, append after findings:

```
### Existing Discussion (not re-raised)
- path/to/file.ext:30 — error handling discussed by @reviewer
- path/to/file.ext:55 — naming concern acknowledged by author
```

Omit if no existing comments overlap with potential findings.

### Summary

End with a numbered summary list:

```
---

## Summary

Files reviewed: N | Critical: X | Major: Y | Minor: Z

1. **Critical** `UserService.ts:42` — Unhandled null reference in user lookup
2. **Major** `OrderController.ts:88` — DB query in controller bypasses service layer
3. **Minor** `utils.py:15` — Magic number 86400 should be SECONDS_PER_DAY
```

If zero issues: output `Files reviewed: N | No issues found.` and stop.
