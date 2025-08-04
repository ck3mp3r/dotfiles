{pkgs, ...}: let
  atuinConfig = pkgs.runCommand "atuin-init-nu" {buildInputs = [pkgs.gnused];} ''
    export HOME=$TMPDIR
    mkdir -p $out
    ${pkgs.atuin}/bin/atuin init nu > $out/init.nu
    sed -i 's/get -i/get -o/g' $out/init.nu
  '';
in {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = false;
    flags = ["--disable-up-arrow"];
    settings = {
      filter_mode = "host";
      enter_accept = false;
      keymap_mode = "vim-normal";
      history_filter = [
        "^cd"
        "^mods"
      ];
    };
  };

  home.file.".config/atuin/init.nu".source = "${atuinConfig}/init.nu";
}
