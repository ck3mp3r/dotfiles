{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";

  agentsRules = ''
    # Personal Rules

    ## Kubernetes Management

    ### Read-only Operations
    You may use kubectl read-only commands directly (get, describe, logs, explain, api-resources, etc.) without asking permission.

    You may also use any k8s_kube_* MCP tools for read-only operations without permission.

    ### Write/Destructive Operations
    NEVER use kubectl write or destructive commands (apply, create, delete, patch, scale, rollout, edit, replace, etc.) without explicit permission **FOR EACH EXECUTION**:

    1. **ALWAYS ASK** the user for explicit permission before **EVERY SINGLE** write operation
    2. Clearly state what changes will be made for THIS specific operation
    3. Wait for confirmation before proceeding
    4. Permission is NEVER implied from previous approvals - you MUST ask again for each new operation

    This applies to:
    - kubectl commands via bash/nushell
    - k8s MCP tools that modify resources (k8s_kube_apply, k8s_kube_create, k8s_kube_patch, k8s_kube_scale, k8s_kube_rollout, etc.)

    **Example**: If you need to apply 3 different manifests, you must ask permission 3 separate times, once before each apply operation.

    Preferred approach: Use the Kubernetes MCP tools (k8s_kube_*) when possible, as they provide better error handling and output formatting.

    ## ArgoCD Management

    ### Read-only Operations
    You may use ArgoCD read-only commands directly without asking permission:
    - `argocd app list`
    - `argocd app get`
    - `argocd app diff`
    - `argocd app logs`
    - `argocd app manifests`
    - `argocd app resources`
    - `argocd app history`
    - Any other read-only operations

    You may also use any argocd_* MCP tools for read-only operations without permission:
    - argocd_list_applications
    - argocd_get_application
    - argocd_get_application_resource_tree
    - argocd_get_application_managed_resources
    - argocd_get_application_workload_logs
    - argocd_get_application_events
    - argocd_get_resource_events
    - argocd_get_resources
    - argocd_get_resource_actions

    ### Write/Destructive Operations
    NEVER use ArgoCD write or destructive commands without explicit permission **FOR EACH EXECUTION**:

    1. **ALWAYS ASK** the user for explicit permission before **EVERY SINGLE** write operation
    2. Clearly state what changes will be made for THIS specific operation
    3. Wait for confirmation before proceeding
    4. Permission is NEVER implied from previous approvals - you MUST ask again for each new operation

    This applies to:
    - ArgoCD CLI commands via bash/nushell: `argocd app create`, `argocd app delete`, `argocd app sync`, `argocd app set`, `argocd app patch`, `argocd app rollback`, etc.
    - ArgoCD MCP tools that modify resources: argocd_create_application, argocd_update_application, argocd_delete_application, argocd_sync_application, argocd_run_resource_action, etc.

    **Example**: If you need to sync 3 different applications, you must ask permission 3 separate times, once before each sync operation.

    Preferred approach: Use the ArgoCD MCP tools (argocd_*) when possible, as they provide better error handling and output formatting.
  '';

  config = {
    "$schema" = "https://opencode.ai/config.json";
    model = "anthropic/claude-sonnet-4.5";
    small_model = "anthropic/claude-haiku-3.5";
    autoupdate = false;

    # Prefer Nushell over Bash
    tools = {
      bash = false;
    };

    # Task agent configuration - uses small_model for speed and token efficiency
    agent = {
      general = {
        description = "General-purpose agent for research and focused tasks with limited tools";
        tools = {
          bash = false;
          write = true;
          edit = true;
          read = true;
          "nu-mcp_run_nushell" = true;
          "context7_resolve_library_id" = true;
          "context7_get_library_docs" = true;
        };
      };
    };
    mcp = {
      nu-mcp = {
        type = "local";
        command = [nuMcp];
        enabled = true;
      };
      weather = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/weather"
        ];
        enabled = true;
      };
      finance = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/finance"
        ];
        enabled = true;
      };
      tmux = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/tmux"
        ];
        enabled = true;
      };
      context7 = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/c67"
        ];
        enabled = true;
      };
      argocd = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/argocd"
        ];
        environment = {
          "MCP_READ_ONLY" = "false";
          "MCP_TOON" = "true";
        };
        enabled = true;
      };
      k8s = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/k8s"
        ];
        environment = {
          "MCP_K8S_MODE" = "non-destructive";
          "MCP_TOON" = "true";
        };
        enabled = true;
      };
    };
  };
in {
  home.file.".config/opencode/opencode.json".text = builtins.toJSON config;
  home.file.".config/opencode/AGENTS.md".text = agentsRules;
  home.packages = [pkgs.opencode pkgs.nu-mcp-tools];
}
