#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$CURRENT_DIR/scripts/helpers.sh"

cpu_interpolation=(
  "\#{cpu_percentage}"
  "\#{cpu_icon}"
  "\#{cpu_bg_color}"
  "\#{cpu_fg_color}"
  "\#{ram_percentage}"
  "\#{ram_icon}"
  "\#{ram_bg_color}"
  "\#{ram_fg_color}"
)
cpu_commands=(
  "#($CURRENT_DIR/scripts/cpu_percentage.sh)"
  "#($CURRENT_DIR/scripts/cpu_icon.sh)"
  "#($CURRENT_DIR/scripts/cpu_bg_color.sh)"
  "#($CURRENT_DIR/scripts/cpu_fg_color.sh)"
  "#($CURRENT_DIR/scripts/ram_percentage.sh)"
  "#($CURRENT_DIR/scripts/ram_icon.sh)"
  "#($CURRENT_DIR/scripts/ram_bg_color.sh)"
  "#($CURRENT_DIR/scripts/ram_fg_color.sh)"
)

set_tmux_option() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

do_interpolation() {
  local all_interpolated="$1"
  for ((i = 0; i < ${#cpu_commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${cpu_interpolation[$i]}/${cpu_commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option
  local option_value
  local new_option_value
  option=$1
  option_value=$(get_tmux_option "$option")
  new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}
main
