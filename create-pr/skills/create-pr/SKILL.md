---
name: create-pr
description: |
  Create a GitHub PR from the current feature branch.
  Auto-detects base branch, learns PR conventions from recent PRs,
  and generates a concise summary with a review guide.
  Use when asked to "create a PR", "open a PR", "make a pull request", or "submit PR".
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
model: Sonnet
context: fork
agent: Explore
---

# Create PR

Create a GitHub PR from the current branch with a convention-aware title and body.

---

## Step 1: Validate Branch State

Confirm the working tree is on a feature branch and has commits to submit.

1. Get the current branch name:
   ```bash
   git branch --show-current
   ```
2. Detect the base branch:
   - Try `gh pr view --json baseRefName -q .baseRefName` (existing PR or draft).
   - Fall back to `gh repo view --json defaultBranchRef -q .defaultBranchRef.name`.
   - Fall back to `main`.
3. Fetch the base branch: `git fetch origin <base> --quiet`.
4. Count commits ahead: `git rev-list --count origin/<base>..HEAD`.

If the current branch **is** the base branch, or there are **zero** commits ahead and **no** uncommitted changes, output **"Nothing to submit — no commits ahead of base branch."** and stop.

If there are uncommitted changes, warn the user that uncommitted changes will not be included in the PR and ask if they want to continue.

---

## Step 2: Learn PR Conventions

Examine recent merged PRs to understand the repo's PR style.

```bash
gh pr list --state merged --limit 5 --json title,body,number
```

Analyze the returned PRs for:
- **Title format**: prefix conventions (e.g., `feat:`, `fix:`, `[JIRA-123]`), capitalization, length
- **Body structure**: section headings, checklist patterns, link conventions

If no merged PRs exist or the repo is new, use a sensible default (concise summary + review guide).

Remember these conventions — you will apply them in Step 4.

---

## Step 3: Gather Diff and Commit History

Collect the information needed to write the PR content.

1. **Commit log**:
   ```bash
   git log --oneline origin/<base>..HEAD
   git log --format="%h %s%n%n%b" origin/<base>..HEAD
   ```
2. **Full diff**:
   ```bash
   git diff origin/<base>...HEAD
   ```
3. **Changed files list**:
   ```bash
   git diff --stat origin/<base>...HEAD
   ```

For large diffs (more than 2000 lines), focus on the `--stat` output and read individual changed files selectively to understand the key changes.

---

## Step 4: Generate PR Title and Body

Using the conventions from Step 2 and the changes from Step 3, generate:

### Title

- Match the repo's convention (prefix style, capitalization, length).
- If no convention detected, use a concise imperative sentence (e.g., "Add user profile caching").
- Keep under 72 characters.

### Body

Structure the body with these two sections (adapt naming if the repo uses different conventions):

```markdown
## Summary

<One paragraph per distinct concept (e.g., new feature, refactoring, bug fix).
Separate paragraphs with a blank line. Each paragraph should be 1-2 sentences.>

## Review guide

- **Start here**: `path/to/key-file.ext` — <why this is the core change>
- <1-2 additional pointers to important files or design decisions>
```

Rules:
- The summary explains **what** this PR does concisely.
- When a PR mixes distinct concerns (e.g., a new feature AND a refactoring, or a bug fix AND a cleanup), write each concern as its own paragraph so readers can distinguish them at a glance.
- The review guide tells reviewers where to start and flags non-obvious design decisions.
- Keep the entire body under 20 lines. Conciseness is mandatory.
- Do not list every file changed. Focus on what matters for understanding and reviewing.
- If the repo's convention includes additional sections (e.g., "Test plan", "Breaking changes"), include them only if relevant.

---

## Step 5: Push and Create PR

1. Push the current branch to origin:
   ```bash
   git push -u origin <current-branch>
   ```
2. Create the PR using a HEREDOC for proper formatting:
   ```bash
   gh pr create --base <base-branch> --title "<title>" --body "$(cat <<'EOF'
   <body>
   EOF
   )"
   ```
3. Output the PR URL returned by `gh pr create`.

If `gh pr create` fails, report the error and stop.
