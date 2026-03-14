# Personal Rules

## 🚨 MANDATORY STARTUP ACTIONS (Run IMMEDIATELY, before anything else)

1. **Load nushell-shell skill** - Run `skill("nushell-shell")` RIGHT NOW before any other action
2. **After EVERY context compaction** - Reload nushell-shell skill immediately as the first action

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

### Task Management (PARAMOUNT)

**When to Use:**
- Multi-step features or bug fixes
- Planning and breaking down complex work
- Tracking progress across sessions
- ANY work requiring multiple steps

**Task Workflow:**
```
1. Find existing: c5t_list_task_lists(project_id=...) - ALWAYS prefer existing lists
2. Create list: c5t_create_task_list(...) - only if no suitable list exists
3. Add tasks: c5t_create_task(list_id=..., title="Fix bug X", priority=1-5)
4. Subtasks: c5t_create_task(..., parent_id=...) [ONE level ONLY - no nested subtasks]
5. Update state: c5t_transition_task(...) - CRITICAL: Update in real-time as work progresses
6. Track: c5t_get_task_list_stats(id=...) to monitor progress
```

**Task State Management (CRITICAL):**
- Update task status IMMEDIATELY when starting/completing work
- backlog → todo → in_progress → review → done
- NEVER batch status updates - update as each task transitions
- Real-time tracking ensures accurate progress visibility

**Projects & Organization:**
- Create project for each major codebase/effort
- Use `c5t_list_projects` to find existing projects before creating duplicates
- Link tasks and repos to projects for discoverability

### Session Notes (Optional)

Use only for critical state that must survive context compaction:
- Complex multi-session work requiring detailed context
- Tag with `session`, link to project(s)
- **After context compaction:** Re-read session notes to restore state

### Context Window Management

**At 80% context window:**
1. Update session note with current state
2. Make descriptive git commit
3. Ask: "Should I summarize before continuing?"

**After context compaction:**
1. Reload nushell-shell skill (MANDATORY)
2. Re-read session notes tagged with `session`
3. Verify critical state is restored

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
