{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";
  yamlFormat = pkgs.formats.yaml {};
  config = {
    GOOSE_PROVIDER = "github_copilot";
    GOOSE_MODEL = "claude-sonnet-4.5";
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
        enabled = false;
        type = "platform";
        name = "Extension Manager";
        description = "Enable extension management tools for discovering, enabling, and disabling extensions";
        bundled = true;
        available_tools = [];
      };
      skills = {
        enabled = false;
        type = "platform";
        name = "skills";
        description = "Load and use skills from .claude/skills or .goose/skills directories";
        bundled = true;
        available_tools = [];
      };
      chatrecall = {
        enabled = false;
        type = "platform";
        name = "chatrecall";
        description = "Search past conversations and load session summaries for contextual memory";
        bundled = true;
        available_tools = [];
      };
      nu-mcp = {
        enabled = true;
        type = "stdio";
        name = "nu-mcp";
        description = "Run nushell commands";
        cmd = nuMcp;
        args = [
          "--add-path=/tmp"
          "--add-path=/nix/store"
        ];
        envs = {};
        env_keys = [];
        timeout = 300;
        bundled = null;
        available_tools = [];
      };
      developer = {
        enabled = true;
        type = "builtin";
        name = "developer";
        description = "Code editing and shell access";
        display_name = "Developer Tools";
        timeout = 300;
        bundled = true;
        available_tools = [];
      };
      autovisualiser = {
        enabled = true;
        type = "builtin";
        name = "autovisualiser";
        description = "Data visualisation and UI generation tools";
        display_name = "Auto Visualiser";
        timeout = 300;
        bundled = true;
        available_tools = [];
      };
      tmux = {
        enabled = true;
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
        enabled = true;
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
        enabled = true;
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
    pkgs.goose-cli
    pkgs.nu-mcp
    pkgs.nu-mcp-tools
  ];
  home.file.".config/goose/config.yaml".source = yamlFormat.generate "goose-config" config;
  home.file.".config/goose/config.yaml".force = true;
}
