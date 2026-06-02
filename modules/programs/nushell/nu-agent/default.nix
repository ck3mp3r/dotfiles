{pkgs, ...}: let
  nuMcp = "${pkgs.nu-mcp}/bin/nu-mcp";
  nuMcpTools = "${pkgs.nu-mcp-tools}/share/nushell/mcp-tools";
in {
  home.file.".config/nushell/nu-agent.nu".text =
    builtins.replaceStrings
    ["NU_MCP_PATH" "NU_MCP_TOOLS_PATH"]
    [nuMcp nuMcpTools]
    (builtins.readFile ./nu-agent.nu);

  home.file.".config/nu-agent/agents/researcher.md".source = ./agents/researcher.md;
  home.file.".config/nu-agent/agents/developer.md".source = ./agents/developer.md;
  home.file.".config/nu-agent/agents/orchestrator.md".source = ./agents/orchestrator.md;
  home.file.".config/nu-agent/agents/reviewer.md".source = ./agents/reviewer.md;
}
