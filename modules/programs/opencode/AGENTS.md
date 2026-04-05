# Personal Rules

## 🚨 MANDATORY STARTUP ACTIONS (Run IMMEDIATELY, before anything else)

1. **Load nushell-shell skill** - Run `skill("nushell-shell")` RIGHT NOW before any other action
2. **Load context skill** - Run `skill("context")` RIGHT NOW before any other action
3. **After EVERY context compaction** - Reload both nushell-shell and context skills immediately as the first action

## 🚨 CRITICAL - Non-Negotiable

1. **NEVER commit to `main`/`master`** - Always create feature branch first
2. **ASK permission for EACH k8s/ArgoCD write operation** (apply, delete, patch, sync, scale, etc.)
3. **Backup before destructive changes** - Stage with `git add` or create backups before refactoring/deleting
4. **TDD & SOLID** - Test first (RED → GREEN → REFACTOR), follow SOLID principles

## Test-Driven Development

**Workflow:** RED (write failing test) → GREEN (make it pass) → REFACTOR (clean up)

- Write tests BEFORE implementation for new features/bug fixes
- Run full test suite before committing
- Never commit failing tests
- Follow SOLID principles during refactoring

## Context Management with c5t

Use tasks for ANY multi-step work. The context skill (loaded at startup) covers the full workflow — key reminders:

- Use tasks for: multi-step features, bug fixes, planning, tracking across sessions
- Create a project per major codebase/effort; link tasks and repos to it
- Use `c5t_list_projects` before creating a new project to avoid duplicates

### Context Window Management

**At 90% context window:**
1. Update session note with current state
2. Make descriptive git commit
3. Ask: "Should I summarize before continuing?"
4. Keep session notes in c5t, tag with `session`

**After context compaction:**
1. Reload nushell-shell skill (MANDATORY)
2. Reload context skill (MANDATORY)
3. Re-read session notes tagged with `session`
4. Verify critical state is restored

## Safety

Before refactoring, large changes, or deletions: stage with `git add` or create backups. Never proceed without a safety net.

## Running commands

1. Don't cd unless you have to
2. Store results in variables so you can query in subsequent tool calls
   - let r = (cargo test | complete)
   - $r.stdout | from json | get foo

## Research First

Before making changes:
1. Read docs: `/llms.txt`, `/AGENTS.md`, `/README.md` (if exist)
2. Use Context7 for API docs and best practices
3. Use Task tool to understand codebase structure

Only after research, proceed with changes.

## Git Workflow

Before ANY code changes:
1. Check branch, switch to main if needed
2. Pull latest: `git pull`
3. Create feature branch: `git checkout -b feature/name`
4. Ask permission: state branch name and planned changes
5. Never auto-commit - always ask first

## Infrastructure (Kubernetes & ArgoCD)

**Read-only** (free use): get, describe, logs, list, diff, etc.

**Write operations** (require permission EACH time):
- apply, create, delete, patch, sync, scale, rollout, etc.
- State what THIS operation changes
- Permission never carries over from previous approvals
- 3 manifests = 3 separate permission requests

Prefer MCP tools (k8s_kube_*, argocd_*) for better error handling.


