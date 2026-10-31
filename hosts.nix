# Per-machine role catalogue.
#
# Keys are `scutil --get LocalHostName` lowercased; bin/hm exports the detected
# hostname as DARWIN_HOST, which flake.nix reads (impure) to pick the entry.
# A hostname without an entry gets no roles, so unlisted machines stay plain.
{
  "christians-mac-mini" = {
    roles = ["inference"];
    # omlx guard ceiling. The 8-bit 27B build is 27.8GB, so a 238k conversation
    # sits near 47GB; the soft target is 0.9x this value (45GB at 50).
    omlx = {
      guardCeilingGb = 50;
    };
  };

  # example: a machine that only runs the normal desktop config
  "christians-mbp16" = {
    roles = [];
  };
}
