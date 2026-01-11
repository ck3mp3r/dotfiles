# Personal Rules

## 🚨 CRITICAL - Non-Negotiable

1. **NEVER commit to `main`/`master`** - Always create feature branch first
2. **ASK permission for EACH k8s/ArgoCD write operation** (apply, delete, patch, sync, scale, etc.)
3. **ONLY Nushell syntax** - This system uses Nushell, not bash/zsh. Common mistakes:
   - ❌ `cmd1 && cmd2` → ✅ `cmd1; cmd2` (Nushell DOES NOT support `&&` operator!)
   - ❌ `cmd1 || cmd2` → ✅ `cmd1; cmd2` or `try { cmd1 } catch { cmd2 }`
   - ❌ `command 2>&1` → ✅ `command | complete`
   - ❌ `command > file 2>&1` → ✅ `command out+err> file`
   - ❌ `command 2> /dev/null` → ✅ `command err> /dev/null`
   - ❌ `command | tail -20` → ✅ `command | lines | last 20`
   - Use Context7 for nushell docs if unsure
4. **Backup before destructive changes** - Stage with `git add` or create backups before refactoring/deleting
5. **TDD & SOLID** - Test first (RED → GREEN → REFACTOR), follow SOLID principles

## Test-Driven Development

**Workflow:** RED (write failing test) → GREEN (make it pass) → REFACTOR (clean up)

- Write tests BEFORE implementation for new features/bug fixes
- Run full test suite before committing
- Never commit failing tests
- Follow SOLID principles during refactoring

## Context Management

At 80% context window:
1. Use c5t to keep a session note up to date (tag with `session`, include: changes, next steps, key files, decisions)
2. Make frequent descriptive commits
3. Ask: "Should I summarize before continuing?"

## Safety

Before refactoring, large changes, or deletions: stage with `git add` or create backups. Never proceed without a safety net.

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

## Nushell Command Reference

**You MUST use Nushell syntax, NOT bash/zsh.** Check this table before every command:

| Bash/Zsh | Nushell | Purpose |
|-----------|---------|---------|
| `cmd1 && cmd2` | `cmd1; cmd2` | **Sequential commands (CRITICAL!)** |
| `cmd1 \|\| cmd2` | `try { cmd1 } catch { cmd2 }` | **Error fallback (CRITICAL!)** |
| `cmd 2>&1` | `cmd \| complete` | Capture stdout+stderr |
| `cmd > file 2>&1` | `cmd out+err> file` | Redirect both to file |
| `cmd 2> /dev/null` | `cmd err> /dev/null` | Suppress stderr |
| `cmd \| tail -n 20` | `cmd \| lines \| last 20` | Last 20 lines |
| `cmd \| head -n 10` | `cmd \| lines \| first 10` | First 10 lines |
| `cmd \| grep pattern` | `cmd \| lines \| find pattern` | Filter lines |
| `export VAR=val` | `$env.VAR = val` | Set environment var |
| `echo $VAR` | `$env.VAR` | Read environment var |

**When unsure:** Use Context7 to fetch Nushell documentation rather than guessing bash syntax.
