#!/usr/bin/env bash

export LC_ALL=C

/usr/bin/pmset -g batt | awk '
  /[0-9]+%;/ {
    match($0, /[0-9]+%/)
    charge = substr($0, RSTART, RLENGTH)
    percentage = charge + 0

    # Match the installed tmux profile battery icons and charge tiers.
    if ($0 ~ /; charging;/) icon = "󰂄"
    else if ($0 ~ /; (charged|AC attached|not charging);/) icon = "󰚥"
    else if (percentage >= 95) icon = "󰂃"
    else if (percentage >= 80) icon = "󰂂"
    else if (percentage >= 65) icon = "󰂁"
    else if (percentage >= 50) icon = "󰂀"
    else if (percentage >= 35) icon = "󰁿"
    else if (percentage >= 20) icon = "󰁾"
    else if (percentage > 5) icon = "󰁼"
    else icon = "󰁺"

    printf "%s %s\n", icon, charge
    exit
  }
'
