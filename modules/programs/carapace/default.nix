{pkgs, ...}: let
  carapaceConfig = pkgs.runCommand "carapace-init-nu" {buildInputs = [pkgs.gnused];} ''
    export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
    export HOME=$TMPDIR
    mkdir -p $out
    ${pkgs.carapace}/bin/carapace _carapace nushell > $out/init.nu
    sed -i 's/get -i/get -o/g' $out/init.nu
  '';
in {
  home.file.".config/nushell/carapace.nu".source = "${carapaceConfig}/init.nu";
  home.packages = [pkgs.carapace];
}
