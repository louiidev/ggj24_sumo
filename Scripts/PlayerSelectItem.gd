extends Panel


#var device_id: int = 0;



func player_connected(color: String):
	var stylebox = StyleBoxFlat.new();
	#theme.bg_color = color;
	#print(theme.bg_color)
	#set_theme(theme)
	stylebox.bg_color = Color.from_string(color, Color.BLACK)
	stylebox.corner_radius_bottom_left = 10
	self.add_theme_stylebox_override("panel", stylebox)
	

	
	
