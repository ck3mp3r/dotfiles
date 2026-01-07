{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";

  config = {
    "$schema" = "https://charm.land/crush.json";

    # MCP server configurations matching OpenCode
    mcp = {
      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
        disabled = true;
        timeout = 300;
      };
      gh = {
        type = "stdio";
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/gh"
        ];
        enabled = true;
      };
      nu-mcp = {
        type = "stdio";
        command = nuMcp;
        args = [
          "--add-path=/tmp"
          "--add-path=/nix/store"
        ];
        disabled = false;
        timeout = 300;
      };
      tmux = {
        type = "stdio";
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/tmux"
        ];
        disabled = false;
        timeout = 300;
      };
      c5t = {
        type = "http";
        url = "http://127.0.0.1:3737/mcp";
        disabled = false;
        timeout = 300;
      };
      context7 = {
        type = "stdio";
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/c67"
        ];
        disabled = false;
        timeout = 300;
      };
      argocd = {
        type = "stdio";
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/argocd"
        ];
        disabled = false;
        timeout = 300;
      };
      k8s = {
        type = "stdio";
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/k8s"
        ];
        disabled = false;
        timeout = 300;
      };
    };

    # Options configuration
    options = {
      debug = false;
      debug_lsp = false;
      data_directory = ".crush";
      initialize_as = "AGENTS.md";

      # Layered context approach:
      # 1. Global rules from ~/.config/crush/AGENTS.md (always loaded)
      # 2. Project-specific AGENTS.md (created per project via initialize_as)
      context_paths = [
        "~/.config/crush/AGENTS.md" # Global rules (your personal workflow)
        "AGENTS.md" # Project-specific context (auto-generated)
      ];

      # Disable heavy built-in tools that consume lots of tokens
      # Use nu-mcp tools instead for better control
      disabled_tools = [
        "bash"
      ];

      # Attribution settings - disabled
      attribution = {
        trailer_style = "none";
        generated_with = false;
      };

      # TUI options
      tui = {
        compact_mode = false;
        diff_mode = "unified";
        completions = {
          max_depth = 3;
          max_items = 1000;
        };
      };
    };

    # Permission settings
    permissions = {
      # Allow safe read-only tools by default
      allowed_tools = [
        "view"
        "ls"
        "grep"
      ];
    };

    # Tool configurations
    tools = {
      ls = {
        max_depth = 3;
        max_items = 1000;
      };
    };
  };
in {
  home.packages = [
    pkgs.nu-mcp
    pkgs.nu-mcp-tools
  ];

  home.file.".config/crush/crush.json".text = builtins.toJSON config;
  # Use the same AGENTS.md as OpenCode - contains personal rules and workflows
  home.file.".config/crush/AGENTS.md".source = ../opencode/AGENTS.md;
}
