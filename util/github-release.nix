{
  name,
  version,
  data,
  pkgs,
}: let
in
  pkgs.stdenvNoCC.mkDerivation rec {
    inherit name version;

    src = pkgs.fetchurl {
      url = builtins.replaceStrings ["{{version}}"] [version] data.url;
      sha256 = data.hash;
    };

    phases = ["unpackPhase" "installPhase"];

    unpackPhase = ''
      tar -xzf ${src}
    '';

    installPhase = ''
      mkdir -p $out/bin
      cp ${name} $out/bin/${name}
      chmod +x $out/bin/${name}
    '';
  }
