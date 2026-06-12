{pkgs, ...}: let
  container = pkgs.stdenvNoCC.mkDerivation {
    pname = "container";
    version = "1.0.0";

    src = pkgs.apple-container-src;

    nativeBuildInputs = with pkgs; [
      libarchive
      xar
      installShellFiles
    ];

    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      xar -xf $src Payload
      bsdtar --extract --file Payload --directory $out
      runHook postInstall
    '';

    postInstall = pkgs.lib.optionalString (pkgs.stdenvNoCC.buildPlatform.canExecute pkgs.stdenvNoCC.hostPlatform) ''
      installShellCompletion --cmd container \
        --bash <($out/bin/container --generate-completion-script bash) \
        --fish <($out/bin/container --generate-completion-script fish) \
        --zsh <($out/bin/container --generate-completion-script zsh)
    '';

    meta = {
      description = "Create and run Linux containers using lightweight virtual machines on a Mac";
      homepage = "https://github.com/apple/container";
      mainProgram = "container";
      platforms = ["aarch64-darwin"];
    };
  };
in {
  home.packages = [container];
}
