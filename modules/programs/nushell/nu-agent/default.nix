{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";
  nuMcpTools = "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools";
  replaceMcpPaths = builtins.replaceStrings ["NU_MCP_PATH" "NU_MCP_TOOLS_PATH"] [nuMcp nuMcpTools];
in {
  home.file.".config/nu-agent/config.toml".text =
    replaceMcpPaths (builtins.readFile ./config.toml);

  home.file.".config/nu-agent/agents/researcher.md".source = ./agents/researcher.md;
  home.file.".config/nu-agent/agents/developer.md".source = ./agents/developer.md;
  home.file.".config/nu-agent/agents/orchestrator.md".source = ./agents/orchestrator.md;
  home.file.".config/nu-agent/agents/reviewer.md".source = ./agents/reviewer.md;

  home.file.".config/nu-agent/hooks/herdr.nu".source = ./hooks/herdr.nu;

  # dev agent
  home.file.".config/nu-agent-dev/config.toml".text =
    replaceMcpPaths (builtins.readFile ./config.toml);

  home.file.".config/nu-agent-dev/agents/researcher.md".source = ./agents/researcher.md;
  home.file.".config/nu-agent-dev/agents/developer.md".source = ./agents/developer.md;
  home.file.".config/nu-agent-dev/agents/orchestrator.md".source = ./agents/orchestrator.md;
  home.file.".config/nu-agent-dev/agents/reviewer.md".source = ./agents/reviewer.md;

  home.file.".config/nu-agent-dev/hooks/herdr.nu".source = ./hooks/herdr.nu;
}
