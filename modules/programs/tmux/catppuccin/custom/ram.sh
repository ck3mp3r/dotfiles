show_ram() {
	local index=$1
  local icon color text module
  
	icon=$(get_tmux_option "@catppuccin_ram_icon" "RAM: #{ram_icon}")
  color=$(get_tmux_option "@catppuccin_ram_color" "$thm_pink")
	text=$(get_tmux_option "@catppuccin_ram_text" "#{ram_percentage}")

	module=$(build_status_module "$index" "$icon" "$color" "$text")

	echo "$module"
}
