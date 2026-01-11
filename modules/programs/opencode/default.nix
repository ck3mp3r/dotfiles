{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";
  agentsRules = builtins.readFile ./AGENTS.md;

  config = {
    "$schema" = "https://opencode.ai/config.json";
    model = "anthropic/claude-sonnet-4.5";
    small_model = "anthropic/claude-haiku-4.5";
    autoupdate = false;

    plugin = [
      "opencode-anthropic-auth@latest"
      "@franlol/opencode-md-table-formatter@latest"
    ];

    permission = {
      "*" = "ask";
      # Disable heavy tools that consume lots of tokens
      grep = "deny";
      glob = "deny";
      # Disable bash/shell tools since we use Nushell via nu-mcp
      bash = "deny";
      shell = "deny";
      # Keep task tool enabled but we'll manage it through agent configuration
      task = "allow";
      # You can also disable other context-heavy tools if needed:
      # read = "deny";  # Uncomment if you want to prevent large file reads
      # list = "deny";  # Uncomment if you want to prevent directory listings

      todowrite = "deny";
      todoread = "deny";

      # Configure nu-mcp run_nushell tool permissions
      nu-mcp_run_nushell = {
        "*" = "ask";
        "cat *" = "allow";
        "git *" = "ask";
        "k *" = "ask";
        "kubectl *" = "ask";
        "ls *" = "allow";
        "rm *" = "deny";
        "rm -rf *" = "deny";
      };
    };

    # Custom provider configuration
    provider = {
      # Thaura AI - Ethical AI Platform
      # Pricing: $0.50/M input tokens, $2.00/M output tokens
      # Dashboard: https://thaura.ai/api-platform
      thaura = {
        npm = "@ai-sdk/openai-compatible";
        name = "Thaura AI";
        options = {
          baseURL = "https://backend.thaura.ai/v1";
        };
        models = {
          "thaura" = {
            name = "Thaura";
          };
        };
      };
      ollama = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama";
        options = {
          baseURL = "http://127.0.0.1:11434/v1";
        };
        models = {
          "devstral-small-2:24b" = {
            name = "devstral-small";
            tools = true;
          };
        };
      };
    };

    # Task agent configuration
    agent = {
      general = {
        description = "General-purpose agent for research and focused tasks with limited tools";
        mode = "subagent";
        # Modern permission-based configuration (replaces deprecated tools config)
        permission = {
          bash = "deny";
          write = "ask";
          edit = "ask";
          read = "allow";
          nu-mcp_run_nushell = "deny";
          context7_resolve_library_id = "allow";
          context7_get_library_docs = "allow";
        };
      };
      thaura = {
        description = "Thaura AI agent for ethical AI research and knowledge management tasks";
        model = "thaura/thaura";
        mode = "subagent";
        # Modern permission-based configuration (replaces deprecated tools config)
        permission = {
          bash = "deny";
          write = "ask";
          edit = "ask";
          read = "allow";
          nu-mcp_run_nushell = "deny";
          context7_resolve_library_id = "allow";
          context7_get_library_docs = "allow";
        };
      };
    };
    mcp = {
      c5t = {
        type = "remote";
        url = "http://0.0.0.0:3737/mcp";
        enabled = true;
      };
      # github = {
      #   type = "remote";
      #   url = "https://api.githubcopilot.com/mcp/";
      #   enabled = true;
      # };
      nu-mcp = {
        type = "local";
        command = [
          nuMcp
          "--add-path"
          "/tmp"
          "--add-path"
          "/nix/store"
        ];
        enabled = true;
      };
      # weather = {
      #   type = "local";
      #   command = [
      #     nuMcp
      #     "--tools-dir"
      #     "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/weather"
      #   ];
      #   enabled = true;
      # };
      # finance = {
      #   type = "local";
      #   command = [
      #     nuMcp
      #     "--tools-dir"
      #     "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/finance"
      #   ];
      #   enabled = true;
      # };
      tmux = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/tmux"
        ];
        enabled = true;
      };
      # c5t = {
      #   type = "local";
      #   command = [
      #     nuMcp
      #     "--tools-dir"
      #     "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/c5t"
      #   ];
      #   enabled = true;
      # };
      gh = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/gh"
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
  home.packages = [pkgs.opencode pkgs.nu-mcp pkgs.nu-mcp-tools];
}
