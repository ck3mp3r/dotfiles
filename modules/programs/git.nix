{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "nvim";
      };
      gpg = {
        format = "ssh";
      };
      "gpg \"ssh\"" = {
        program =
          if pkgs.stdenv.isLinux
          then "TODO:define this"
          else "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
      "credential \"https://github.com\"" = {
        helper = ["" "${pkgs.gh}/bin/gh auth git-credential"];
      };
      "credential \"https://gitst.github.com\"" = {
        helper = ["" "${pkgs.gh}/bin/gh auth git-credential"];
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictstyle = "diff3";
        tool = "nvimdiff";
      };
      mergetool.nvimdiff.cmd = "nvim -d $LOCAL $REMOTE $MERGED";
      diff = {colorMoved = "default";};
    };
  };

  catppuccin.delta = {
    enable = true;
    flavor = "mocha";
  };
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      light = false;
      side-by-side = true;
      line-numbers = true;
      true-color = "always";
    };
  };
}
