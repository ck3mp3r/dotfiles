{pkgs, ...}: {
  home.file.".config/opencode/opencode.json".source = ./opencode.json;
  home.packages = [pkgs.opencode pkgs.tmux-mcp-tools];
  home.file.".local/share/nushell/mcp-tools/tmux".source = "${pkgs.tmux-mcp-tools}/share/nushell/mcp-tools/tmux";
  home.file.".local/share/nushell/mcp-tools/weather".source = "${pkgs.weather-mcp-tools}/share/nushell/mcp-tools/weather";
  home.file.".local/share/nushell/mcp-tools/finance".source = "${pkgs.finance-mcp-tools}/share/nushell/mcp-tools/finance";
}
