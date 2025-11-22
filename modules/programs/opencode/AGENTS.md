# Personal Rules

## Research First, Code Second

Before ANY changes:
1. **Read docs**: `/llms.txt` → `/AGENTS.md` → `/README.md`
2. **Research libraries**: Use Context7 for API docs and best practices
3. **Understand codebase**: Use Task tool to explore structure and patterns

## Git Workflow

**Protected branches**: NEVER commit to `main` or `master`.

**Before code changes**:
1. Check current branch
2. **Always ask before switching branches** (provide branch name and reason)
3. After switching to main: `git pull`
4. Create new branch from main—**ALL branches MUST come from main** (e.g., `feature/add-logging`, `fix/bug`, `refactor/cleanup`)
5. **Ask permission**: State branch name (from main) and planned changes
6. Wait for confirmation
7. **Never auto-commit or auto-merge PRs**

**PR merges**:
- Only merge PRs if explicitly requested
- Default to `--squash` merge unless otherwise instructed
- Always confirm before executing the merge

Applies to ALL repositories.

## Kubernetes Operations

**Read-only**: Use kubectl/k8s_kube_* tools freely (get, describe, logs, explain, etc.)

**Write/destructive**: ALWAYS ask permission **FOR EACH EXECUTION** before:
- kubectl: apply, create, delete, patch, scale, rollout, edit, replace
- k8s_kube_*: apply, create, patch, scale, rollout

Permission NEVER carries over—ask again for each operation.

Prefer k8s_kube_* MCP tools for better error handling.

## ArgoCD Operations

**Read-only**: Use argocd CLI/argocd_* MCP tools freely (list, get, diff, logs, resources, etc.)

**Write/destructive**: ALWAYS ask permission **FOR EACH EXECUTION** before:
- CLI: create, delete, sync, set, patch, rollback
- MCP: argocd_create_application, argocd_update_application, argocd_delete_application, argocd_sync_application, argocd_run_resource_action

Permission NEVER carries over—ask again for each operation.

Prefer argocd_* MCP tools for better error handling.

## File System Operations

**Read-only**: Read, glob, grep, list files freely.

**Destructive/irreversible**: ALWAYS ask permission **FOR EACH EXECUTION** before:
- Deleting files or directories (rm, rmdir, etc.)
- Moving/renaming files (mv, rename)
- Overwriting files with redirects (>, etc.)
- Recursive operations (rm -r, chmod -R, etc.)
- Permission changes (chmod, chown)
- Any command that permanently removes or modifies data

Permission NEVER carries over—ask again for each operation.
