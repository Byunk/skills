#!/usr/bin/env bash
# Detect code review mode: pr, local, or branch
# Outputs: MODE, PR_NUMBER, BASE_BRANCH

set -euo pipefail

ARGUMENTS="${1:-}"
MODE=""
PR_NUMBER=""
BASE_BRANCH=""

# Check if arguments contain a PR number
if echo "$ARGUMENTS" | grep -qE '(^|[^a-zA-Z0-9])#?([0-9]+)($|[^a-zA-Z0-9])'; then
  PR_NUMBER=$(echo "$ARGUMENTS" | grep -oE '[0-9]+' | head -1)
  # Verify PR exists
  if gh pr view "$PR_NUMBER" --json number -q .number 2>/dev/null; then
    MODE="pr"
  fi
fi

# If not PR mode, check for local changes
if [ -z "$MODE" ]; then
  LOCAL_CHANGES=$(git status --porcelain 2>/dev/null)
  if [ -n "$LOCAL_CHANGES" ]; then
    MODE="local"
  fi
fi

# If not local mode, check for branch commits
if [ -z "$MODE" ]; then
  BASE_BRANCH=$(gh pr view --json baseRefName -q .baseRefName 2>/dev/null \
    || gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null \
    || echo "main")
  git fetch origin "$BASE_BRANCH" --quiet 2>/dev/null
  AHEAD=$(git rev-list --count "origin/$BASE_BRANCH..HEAD" 2>/dev/null || echo "0")
  if [ "$AHEAD" -gt 0 ]; then
    MODE="branch"
  fi
fi

# Resolve base branch for non-PR modes if not set
if [ -z "$BASE_BRANCH" ] && [ "$MODE" != "pr" ]; then
  BASE_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name 2>/dev/null || echo "main")
fi

echo "MODE: $MODE"
echo "PR_NUMBER: $PR_NUMBER"
echo "BASE_BRANCH: $BASE_BRANCH"
