#!/usr/bin/env bash

export LC_ALL=C

/usr/sbin/ioreg -r -d 1 -w 0 -c IOAccelerator | awk '
  match($0, /"Device Utilization %"=[0-9]+/) {
    value = substr($0, RSTART, RLENGTH)
    sub(/.*=/, "", value)
    if (!found || value + 0 > usage) usage = value + 0
    found = 1
  }
  END {
    if (found) printf "󰾲 %.1f%%\n", usage
    else print "󰾲 N/A"
  }
'
