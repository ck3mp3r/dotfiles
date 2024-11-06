show_cpu() {
	local index=$1
	local icon color text module
  
	icon=$(get_tmux_option "@catppuccin_cpu_icon" "CPU: #{cpu_icon}")
	color=$(get_tmux_option "@catppuccin_cpu_color" "$thm_yellow")
	text=$(get_tmux_option "@catppuccin_cpu_text" "#{cpu_percentage}")

	module=$(build_status_module "$index" "$icon" "$color" "$text")

	echo "$module"
}
