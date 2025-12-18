# Personal Rules

## Core Development Philosophy

### Test-Driven Development (TDD)

**TDD is MANDATORY for all code changes.**

Follow the Red-Green-Refactor cycle:
1. **Red**: Write a failing test that defines expected behavior
2. **Green**: Write minimal code to make the test pass
3. **Refactor**: Clean up while keeping tests green

Key principles:
- **Tests first, always** - No implementation without a failing test
- **One test at a time** - Don't batch tests before implementing
- **Run tests constantly** - After every small change
- **Bug fixes require tests** - Reproduce the bug in a test BEFORE fixing
- **If tests are hard to write** - The design needs simplification

### Safety First

Before refactoring, large-scale changes, or deletions:
- **Stage changes**: `git add` before destructive operations
- **Never proceed without a safety net**

## Environment

### Shell (Nushell)

This system uses **Nushell**, NOT bash/zsh/sh. Use Context7 for syntax when unsure.

Quick reference:
```nushell
cmd1; cmd2              # chaining (not &&)
cmd | ignore            # discard output (not > /dev/null)
$env.FOO = "bar"        # set env var (not export)
"hello" | save file.txt # redirect (not >)
```

### Git Workflow

**NEVER commit to `main`/`master`.**

Before ANY code changes:
1. Check current branch, switch to main if needed
2. Pull latest: `git pull`
3. Create feature branch from main (e.g., `tdd/add-feature`)
4. Ask permission: state branch name and planned changes
5. Never auto-commit - always ask first

## Research Before Action

Before making ANY changes:
1. **Read docs**: `/llms.txt`, `/AGENTS.md`, `/README.md`
2. **Research dependencies**: Use Context7 for API docs and best practices
3. **Understand codebase**: Use Task tool to explore structure and patterns

Only after research, proceed with branch creation and changes.

## Context Management

Before reaching 80% of context window:
1. Create `.work-progress.md` documenting changes, next steps, key files, and decisions
2. Make frequent, descriptive git commits - use git history as memory
3. For long sessions, ask: "Should I summarize progress before continuing?"

## Infrastructure (Kubernetes & ArgoCD)

**Read-only**: Use kubectl/argocd commands and k8s_kube_*/argocd_* MCP tools freely (get, describe, logs, list, diff, etc.)

**Write/Destructive**: **ALWAYS ASK permission FOR EACH operation** (apply, create, delete, patch, sync, scale, rollout, etc.)
- State what changes will be made for THIS specific operation
- Permission is NEVER implied from previous approvals
- If applying 3 manifests, ask 3 times

Prefer MCP tools (k8s_kube_*, argocd_*) for better error handling.

## Tool Output Display

**CRITICAL**: When tools have "DISPLAY OUTPUT TO USER" or "MUST be displayed" in their description:
1. **ALWAYS show the FULL tool output** in your response
2. **NEVER** summarize or paraphrase the output
3. Display raw output FIRST, then optionally add brief context AFTER
