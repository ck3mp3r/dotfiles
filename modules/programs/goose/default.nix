{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";
  yamlFormat = pkgs.formats.yaml {};
  goose-cli-nocheck = pkgs.goose-cli.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
  config = {
    GOOSE_PROVIDER = "github_copilot";
    GOOSE_MODEL = "claude-sonnet-4.5";
    CONTEXT_FILE_NAMES = ''["AGENTS.md"]'';
    GOOSE_RECIPE_PATH = "$HOME/.config/goose/recipes";
    GOOSE_TELEMETRY_ENABLED = false;
    extensions = {
      # github = {
      #   enabled = true;
      #   type = "streamable_http";
      #   name = "github";
      #   description = "Github Copilot MCP";
      #   uri = "https://api.githubcopilot.com/mcp/";
      #   envs = {};
      #   env_keys = [];
      #   headers = {};
      #   timeout = 300;
      #   bundled = null;
      #   available_tools = [];
      # };
      context = {
        enabled = true;
        type = "streamable_http";
        name = "context";
        description = "Context Task and Information Management";
        uri = "http://localhost:3737/mcp";
        envs = {};
        env_keys = [];
        headers = {};
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      todo = {
        enabled = false;
        type = "platform";
        name = "todo";
        description = "Enable a todo list for Goose so it can keep track of what it is doing";
        bundled = true;
        available_tools = [];
      };
      extensionmanager = {
        enabled = true;
        type = "platform";
        name = "Extension Manager";
        description = "Enable extension management tools for discovering, enabling, and disabling extensions";
        bundled = true;
        available_tools = [];
      };
      skills = {
        enabled = true;
        type = "platform";
        name = "skills";
        description = "Load and use skills from .claude/skills or .goose/skills directories";
        bundled = true;
        available_tools = [];
      };
      chatrecall = {
        enabled = true;
        type = "platform";
        name = "chatrecall";
        description = "Search past conversations and load session summaries for contextual memory";
        bundled = true;
        available_tools = [];
      };
      nu-mcp = {
        enabled = true;
        type = "stdio";
        name = "nu";
        description = "Run nushell commands";
        cmd = nuMcp;
        args = [
          "--add-path=/tmp"
          "--add-path=/nix/store"
          "--add-path=$HOME/.local"
          "--add-path=$HOME/Projects"
        ];
        envs = {
          GIT_PAGER = "";
        };
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      developer = {
        enabled = true;
        type = "builtin";
        name = "developer";
        description = "Code editing and shell access (shell/bash disabled - use nu)";
        display_name = "Developer Tools";
        timeout = 300;
        bundled = true;
        available_tools = [
          # File operations
          "read"
          "write"
          "edit"
          "create_file"
          "str_replace"
          "text_editor"
          "list_dir"
          "list_files"
          "grep"
          "file_str_replace"
          "insert_text_after_context"

          # Git operations (safe, read-only or interactive)
          "git_status"
          "git_diff"
          "git_log"
          "git_show"
          "git_branch"

          # Explicitly exclude:
          # - shell (use nu instead)
          # - bash (use nu instead)
        ];
      };
      autovisualiser = {
        enabled = false;
        type = "builtin";
        name = "autovisualiser";
        description = "Data visualisation and UI generation tools";
        display_name = "Auto Visualiser";
        timeout = 300;
        bundled = true;
        available_tools = [];
      };
      tmux = {
        enabled = false;
        type = "stdio";
        name = "tmux";
        description = "Tmux session management";
        cmd = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/tmux"
        ];
        envs = {};
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      context7 = {
        enabled = false;
        type = "stdio";
        name = "context7";
        description = "Context7 documentation access";
        cmd = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/c67"
        ];
        envs = {};
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      gh = {
        enabled = false;
        type = "stdio";
        name = "github";
        description = "Github MCP";
        cmd = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/gh"
        ];
        envs = {};
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      argocd = {
        enabled = false;
        type = "stdio";
        name = "argocd";
        description = "ArgoCD management";
        cmd = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/argocd"
        ];
        envs = {};
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      k8s = {
        enabled = false;
        type = "stdio";
        name = "k8s";
        description = "Kubernetes management";
        cmd = nuMcp;
        args = [
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/k8s"
        ];
        envs = {};
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
    };
  };
in {
  home.packages = [
    goose-cli-nocheck
    pkgs.nu-mcp
    pkgs.nu-mcp-tools
  ];
  home.file.".config/goose/config.yaml".source = yamlFormat.generate "goose-config" config;
  home.file.".config/goose/config.yaml".force = true;

  # Symlink OpenCode AGENTS.md into Goose config directory
  home.file.".config/goose/AGENTS.md".source = ../opencode/AGENTS.md;

  # Install subagent recipes
  home.file.".config/goose/recipes/research-assistant.yaml".source = ./recipes/research-assistant.yaml;
  home.file.".config/goose/recipes/code-reviewer.yaml".source = ./recipes/code-reviewer.yaml;
  home.file.".config/goose/recipes/documentation-writer.yaml".source = ./recipes/documentation-writer.yaml;
  home.file.".config/goose/recipes/testing-assistant.yaml".source = ./recipes/testing-assistant.yaml;
  home.file.".config/goose/recipes/refactoring-assistant.yaml".source = ./recipes/refactoring-assistant.yaml;
  home.file.".config/goose/recipes/README.md".source = ./recipes/README.md;
}
