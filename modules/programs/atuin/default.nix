{pkgs, ...}: let
  atuin-nocheck = pkgs.atuin.overrideAttrs (oldAttrs: {
    doCheck = false;
  });
  atuinConfig = pkgs.runCommand "atuin-init-nu" {buildInputs = [pkgs.gnused];} ''
    export HOME=$TMPDIR
    mkdir -p $out
    ${atuin-nocheck}/bin/atuin init nu --disable-up-arrow > $out/init.nu
    sed -i 's/get -i/get -o/g' $out/init.nu
  '';
in {
  programs.atuin = {
    enable = true;
    enableNushellIntegration = false;
    package = atuin-nocheck;
    flags = ["--disable-up-arrow"];
    settings = {
      filter_mode = "global";
      enter_accept = false;
      keymap_mode = "vim-normal";
      history_filter = [
        "^cd"
        "^mods"
      ];
    };
  };

  home.file.".config/nushell/atuin.nu".source = "${atuinConfig}/init.nu";
}
