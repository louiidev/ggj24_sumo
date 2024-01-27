extends Panel


#var device_id: int = 0;

@onready var label: Label = $Label

func player_connected(color: String, device_id: int):
	var stylebox = StyleBoxFlat.new();
	stylebox.bg_color = Color.from_string(color, Color.BLACK)
	stylebox.corner_radius_bottom_left = 10
	self.add_theme_stylebox_override("panel", stylebox)
	label.text = "Player " + str(device_id + 1)

	
	
