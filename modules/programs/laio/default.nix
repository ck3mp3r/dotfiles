{pkgs, ...}: let
  laioConfig = pkgs.runCommand "laio-init-nu" {buildInputs = [pkgs.gnused];} ''
    export HOME=$TMPDIR
    mkdir -p $out
    ${pkgs.laio}/bin/laio completion nushell > $out/init.nu
    sed -i 's/get -i/get -o/g' $out/init.nu
  '';
in {
  home.file.".config/nushell/laio.nu".source = "${laioConfig}/init.nu";
  home.packages = [pkgs.laio pkgs.tmux-mcp-tools];
  home.file.".local/share/nushell/mcp-tools/tmux/tmux.nu".source = "${pkgs.tmux-mcp-tools}/share/nushell/mcp-tools/tmux/tmux.nu";
}
