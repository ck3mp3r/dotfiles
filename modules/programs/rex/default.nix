{
  homeDirectory,
  hostConfig ? {},
  pkgs,
  ...
}: let
  # A Rex server on another machine, reached through the ssh -L forward that
  # modules/darwin.nix runs. hosts.nix decides which machines get one; the
  # socket path matches that module, and the forward only exists there.
  forward = hostConfig.rex.sshForward or null;
  encode = builtins.replaceStrings [" "] ["%20"];
  hostsLua =
    if forward == null
    then ""
    else ''
      rex.host{
        label = "${forward.label}",
        endpoints = {"unix://${encode "${homeDirectory}/Library/Application Support/rex/ssh/${forward.label}.sock"}"},
      }
    '';
in {
  # The Rex server starts a block's program with its own minimal PATH, so the
  # laio picker action gets laio's store path instead of a bare `laio`.
  home.file.".config/rex/init.lua".text =
    builtins.replaceStrings
    ["@laio@" "@hosts@"]
    ["${pkgs.laio}/bin/laio" hostsLua]
    (builtins.readFile ./init.lua);
}
