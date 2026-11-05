{pkgs, ...}: {
  # The Rex server starts a block's program with its own minimal PATH, so the
  # laio picker action gets laio's store path instead of a bare `laio`.
  home.file.".config/rex/init.lua".text =
    builtins.replaceStrings
    ["@laio@"]
    ["${pkgs.laio}/bin/laio"]
    (builtins.readFile ./init.lua);
}
