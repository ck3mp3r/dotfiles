#!/usr/bin/env bash

export LC_ALL=C

# Same used-minus-cache ratio as tmux; page size cancels out.
/usr/bin/vm_stat | awk -F: '
  /^Pages (active|inactive|speculative|wired down|occupied by compressor):/ {
    used += $2 + 0
  }
  /^(Pages purgeable|File-backed pages):/ { cached += $2 + 0 }
  /^Pages free:/ { free = $2 + 0 }
  END {
    total = used + free
    if (total > 0) printf "󰘚 %.1f%%\n", 100 * (used - cached) / total
    else print "󰘚 N/A"
  }
'
