{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";

  config = {
    default-api = "copilot";
    default-model = "gpt-4.1";
    max-retries = 5;
    theme = "catppuccin";

    apis = {
      ollama = {
        base-url = "http://localhost:11434";
        models = {
          "devstral:latest" = {
            aliases = ["devstral"];
            max-input-chars = 650000;
          };
          "qwen3:8b" = {
            aliases = ["qwen3"];
            max-input-chars = 650000;
          };
          "llama3.2:latest" = {
            aliases = ["llama3"];
            max-input-chars = 650000;
          };
        };
      };

      copilot = {
        base-url = "https://api.githubcopilot.com";
        models = {
          "gpt-4.1" = {
            aliased = ["4.1"];
            max-input-chars = 680000;
          };
          "gpt-4" = {
            aliased = ["4"];
            max-input-chars = 680000;
          };
          "claude-3.7-sonnet" = {
            aliases = ["claude3.7-sonnet" "sonnet-3.7" "claude-3-7-sonnet"];
            max-input-chars = 680000;
          };
          "claude-sonnet-4" = {
            aliases = ["sonnet-4" "claude-4-sonnet"];
            max-input-chars = 680000;
          };
        };
      };
    };

    mcp-servers = {
      nu-mcp = {
        command = nuMcp;
      };
      tmux = {
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/tmux"
        ];
      };
      finance = {
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/finance"
        ];
      };
      weather = {
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/weather"
        ];
      };
      context7 = {
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/c67"
        ];
      };
      k8s = {
        command = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/k8s"
        ];
      };
    };
  };
in {
  home.file.".config/mods/mods.yml".text = builtins.toJSON config;
  home.packages = [
    pkgs.mods
    pkgs.nu-mcp
    pkgs.nu-mcp-tools
  ];
}
