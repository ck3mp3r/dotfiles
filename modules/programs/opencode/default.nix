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
