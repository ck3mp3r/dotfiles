show_path() {
	local current_path smartpath index icon color text module

	# path=$(echo "#{pane_current_path}" | sed \"s|^${HOME}|~|\" | awk -F/ -v OFS=/ -v len=20 '{ if (length(\$0) > len && NF > 4) print \$1,\$2 \"...\", \$(NF-1), \$NF; else print \$0; }')

	current_path="#{pane_current_path}" # Replace with actual path fetching

	smartpath="${current_path/#$HOME/~}"
  
	index=$1
	icon=$(get_tmux_option "@catppuccin_directory_icon" "")
	color=$(get_tmux_option "@catppuccin_directory_color" "$thm_pink")
	text=$(get_tmux_option "@catppuccin_directory_text" "$smartpath")

	module=$(build_status_module "$index" "$icon" "$color" "$text")

	echo "$module"
}
