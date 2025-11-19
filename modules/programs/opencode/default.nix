{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";

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
  home.packages = [pkgs.opencode pkgs.nu-mcp-tools];
}
