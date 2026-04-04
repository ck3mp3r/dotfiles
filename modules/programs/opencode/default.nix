{
  pkgs,
  config,
  ...
}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";
  homeDir = config.home.homeDirectory;

  opencode-config = {
    "$schema" = "https://opencode.ai/config.json";
    model = "github-copilot/claude-sonnet-4.5";
    small_model = "github-copilot/claude-haiku-4.5";
    autoupdate = false;

    # Disable LSP support globally
    lsp = false;

    plugin = [
      "opencode-anthropic-auth@latest"
      # "@franlol/opencode-md-table-formatter@latest"
    ];

    permission = {
      "*" = "ask";
      read = "allow";
      grep = "allow";
      glob = "allow";
      webfetch = "allow";
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

      "context7*" = "allow";

      "c5t_get*" = "allow";
      "c5t_list*" = "allow";
      "c5t_read*" = "allow";
      # Configure nu_run tool permissions
      nu_run = {
        "*" = "ask";
        "cargo test" = "allow";
        "cargo test *" = "allow";
        "cat *" = "allow";
        "git *" = "ask";
        "k *" = "ask";
        "kubectl *" = "ask";
        "ls *" = "allow";
        "rm *" = "deny";
        "rm -rf *" = "deny";
      };
      tmux_capture_pane = "allow";
      "tmux_list_*" = "allow";
      "tmux_get_*" = "allow";
      "tmux_find_*" = "allow";

      # Skill permissions - auto-load mandatory and nushell-related skills
      skill = {
        "*" = "ask"; # Ask for other skills by default
        # MANDATORY startup skills (from AGENTS.md)
        "nushell-shell" = "allow";
        "context" = "allow";
        # Auto-load all nushell-related skills
        "nushell-*" = "allow";
      };
    };

    # Custom provider configuration
    provider = {
      # GitHub Copilot - Override context limits for Claude models
      github-copilot = {
        models = {
          "claude-opus-4.6" = {
            limit = {
              context = 200000;
              output = 8192;
            };
          };
          "claude-sonnet-4.6" = {
            limit = {
              context = 200000;
              output = 8192;
            };
          };
          "claude-opus-4.5" = {
            limit = {
              context = 200000;
              output = 8192;
            };
          };
          "claude-sonnet-4.5" = {
            limit = {
              context = 200000;
              output = 8192;
            };
          };
          "claude-haiku-4.5" = {
            limit = {
              context = 200000;
              output = 8192;
            };
          };
        };
      };
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
            limit = {
              context = 131072;
              output = 65536;
            };
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
            tool_call = true;
            limit = {
              context = 131072;
              output = 8192;
            };
          };
          "qwen3-coder:30b" = {
            name = "qwen3";
            tool_call = true;
            limit = {
              context = 32768;
              output = 8192;
            };
          };
          "qwen3-coder-next:latest" = {
            name = "qwen3-next";
            tool_call = true;
            limit = {
              context = 262144;
              output = 8192;
            };
          };
          "qwen3.5:35b" = {
            name = "qwen3.5";
            tool_call = true;
            limit = {
              context = 262144;
              output = 8192;
            };
          };
        };
      };
      ollama-mlx = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama-Mlx";
        options = {
          baseURL = "http://192.168.1.73:8080/v1";
        };
        models = {
          "mlx-community/Qwen3-Coder-Next-4bit" = {
            name = "qwen3-next";
            tool_call = true;
            limit = {
              context = 262144;
              output = 8192;
            };
          };
        };
      };

      ollama-remote = {
        npm = "@ai-sdk/openai-compatible";
        name = "Ollama-Remote";
        options = {
          baseURL = "http://192.168.1.73:11434/v1";
        };
        models = {
          "devstral-small-2:24b" = {
            name = "devstral-small";
            tool_call = true;
            limit = {
              context = 131072;
              output = 8192;
            };
          };
          "qwen3-coder:30b" = {
            name = "qwen3";
            tool_call = true;
            limit = {
              context = 32768;
              output = 8192;
            };
          };
          "qwen3-coder-next:latest" = {
            name = "qwen3-next";
            tool_call = true;
            limit = {
              context = 262144;
              output = 8192;
            };
          };
          "qwen3.5:35b" = {
            name = "qwen3.5";
            tool_call = true;
            limit = {
              context = 262144;
              output = 8192;
            };
          };
        };
      };
    };

    # Task agent configuration
    agent = {
      # Override built-in general subagent to deny nushell and allow only read-only tmux
      general = {
        description = "General-purpose agent for research and focused tasks with limited tools";
        mode = "subagent";
        permission = {
          "*" = "ask";
          "c5t_get*" = "allow";
          "c5t_list*" = "allow";
          "c5t_read*" = "allow";
          "context7*" = "allow";
          bash = "deny";
          grep = "allow";
          glob = "allow";
          read = "allow";
          nu_run = "deny";
          task = "deny";
          "tmux_*" = "deny";
          tmux_capture_pane = "allow";
          "tmux_list_*" = "allow";
          "tmux_get_*" = "allow";
          "tmux_find_*" = "allow";
          # Auto-load mandatory skills from AGENTS.md
          skill = {
            "*" = "ask";
            "nushell-shell" = "allow";
            "context" = "allow";
            "nushell-*" = "allow";
          };
        };
      };
      # Override built-in explore subagent to deny nushell and allow only read-only tmux
      explore = {
        description = "Fast agent specialized for exploring codebases";
        mode = "subagent";
        permission = {
          "*" = "ask";
          "c5t_get*" = "allow";
          "c5t_list*" = "allow";
          "c5t_read*" = "allow";
          "context7*" = "allow";
          bash = "deny";
          grep = "allow";
          glob = "allow";
          read = "allow";
          nu_run = "deny";
          task = "deny";
          "tmux_*" = "deny";
          tmux_capture_pane = "allow";
          "tmux_list_*" = "allow";
          "tmux_get_*" = "allow";
          "tmux_find_*" = "allow";
          # Auto-load mandatory skills from AGENTS.md
          skill = {
            "*" = "ask";
            "nushell-shell" = "allow";
            "context" = "allow";
            "nushell-*" = "allow";
          };
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
          nu_run = "deny";
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
      c5t-dev = {
        type = "remote";
        url = "http://0.0.0.0:3738/mcp";
        enabled = false;
      };
      # github = {
      #   type = "remote";
      #   url = "https://api.githubcopilot.com/mcp/";
      #   enabled = true;
      # };
      nushell = {
        type = "local";
        command = [
          "nu"
          "--mcp"
        ];
        enabled = false;
      };
      nu-dev = {
        type = "local";
        command = [
          "${homeDir}/Projects/ck3mp3r/nu-mcp/target/debug/nu-mcp"
          "--add-path"
          "/tmp"
          "--add-path"
          "/nix/store"
          "--add-path"
          "${homeDir}/.local"
        ];
        environment = {
          MCP_PTY_TRACE = "1";
        };
        enabled = false;
      };
      nu = {
        type = "local";
        command = [
          nuMcp
          "--add-path"
          "/tmp"
          "--add-path"
          "/nix/store"
          "--add-path"
          "${homeDir}/.local"
          "--add-path"
          "${homeDir}/Projects"
        ];
        environment = {
          "GIT_PAGER" = "";
        };
        enabled = true;
      };
      weather = {
        type = "local";
        command = [
          "${homeDir}/Projects/ck3mp3r/nu-mcp/target/debug/nu-mcp"
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/weather"
        ];
        enabled = false;
      };
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
        enabled = false;
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
        enabled = false;
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
        enabled = false;
      };
    };
  };
in {
  home.file.".config/opencode/opencode.json".text = builtins.toJSON opencode-config;
  home.file.".config/opencode/AGENTS.md".source = ./AGENTS.md;
  home.packages = [pkgs.opencode pkgs.nu-mcp pkgs.nu-mcp-tools];
}
