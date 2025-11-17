{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";

  config = {
    "$schema" = "https://opencode.ai/config.json";
    model = "anthropic/claude-sonnet-4.5";
    autoupdate = false;
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
      k8s = {
        type = "local";
        command = [
          nuMcp
          "--tools-dir"
          "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools/k8s"
        ];
        # environment = {
        #   "MCP_K8S_MODE" = "destructive";
        # };
        enabled = true;
      };
    };
  };
in {
  home.file.".config/opencode/opencode.json".text = builtins.toJSON config;
  home.packages = [pkgs.opencode pkgs.nu-mcp-tools];
}
