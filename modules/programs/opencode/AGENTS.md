
# Personal Rules

## Shell Environment

This system uses **Nushell**, NOT bash/zsh/sh. Before executing ANY shell commands, **use Context7** to learn Nushell syntax. Never assume bash/sh syntax will work.

## Context Management

Before reaching 80% of context window:
1. Create `.work-progress.md` documenting changes, next steps, key files, and decisions
2. Make frequent, descriptive git commits - use git history as memory
3. For long sessions, ask: "Should I summarize progress before continuing?"

## Safety: Backup Before Destructive Changes

Before refactoring, large-scale changes, or deletions: **stage changes with `git add`** or create backups. Never proceed without a safety net.

## Initial Research

Before making ANY changes:
1. **Read docs**: `/llms.txt`, `/AGENTS.md`, `/README.md`
2. **Research dependencies**: Use Context7 for API docs and best practices
3. **Understand codebase**: Use Task tool to explore structure and patterns

Only after research, proceed with branch creation and changes.

## Git Branch Management

**NEVER commit to `main`/`master`.**

Before ANY code changes:
1. Check current branch, switch to main if needed
2. Pull latest: `git pull`
3. Create feature branch from main (e.g., `feature/add-logging`)
4. Ask permission: state branch name and planned changes
5. Never auto-commit - always ask first

Applies to ALL repositories.

## Infrastructure Management (Kubernetes & ArgoCD)

**Read-only**: Use kubectl/argocd commands and k8s_kube_*/argocd_* MCP tools freely (get, describe, logs, list, diff, etc.)

**Write/Destructive**: **ALWAYS ASK permission FOR EACH operation** (apply, create, delete, patch, sync, scale, rollout, etc.)
- State what changes will be made for THIS specific operation
- Permission is NEVER implied from previous approvals
- If applying 3 manifests, ask 3 times

Prefer MCP tools (k8s_kube_*, argocd_*) for better error handling.

