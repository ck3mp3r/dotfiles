#!/usr/bin/env bash

export LC_ALL=C

/usr/sbin/iostat -c 2 -w 1 disk0 | awk '
  / us sy id / {
    for (i = 1; i <= NF; i++) if ($i == "id") idle = i
    next
  }
  idle && NF >= idle { usage = 100 - $idle; found = 1 }
  END {
    if (found) printf "󰻠 %.1f%%\n", usage
    else print "󰻠 N/A"
  }
'
