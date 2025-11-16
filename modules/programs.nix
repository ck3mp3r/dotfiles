{pkgs, ...}: {
  # Let Home Manager install and manage itself.
  #  home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = false;
    package = pkgs.direnv.overrideAttrs (oldAttrs: {
      nativeBuildInputs = builtins.filter (x: (x.pname or x.name or "") != "fish") oldAttrs.nativeBuildInputs;
      doCheck = false;
    });
  };

  programs.fzf.enable = true;
  programs.helix.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.less.enable = true;
  programs.lesspipe.enable = true;
  programs.zoxide.enable = true;
}
