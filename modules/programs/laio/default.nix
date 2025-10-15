{pkgs, ...}: let
  laioConfig = pkgs.runCommand "laio-init-nu" {buildInputs = [pkgs.gnused];} ''
    export HOME=$TMPDIR
    mkdir -p $out
    ${pkgs.laio}/bin/laio completion nushell > $out/init.nu
    sed -i 's/get -i/get -o/g' $out/init.nu
  '';
in {
  home.file.".config/nushell/laio.nu".source = "${laioConfig}/init.nu";
  home.packages = [pkgs.laio];
}
