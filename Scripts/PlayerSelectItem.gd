extends Panel


var portrait_paths = [
	"green.jpg",
	"red.webp",
	"yellow.jpg",
	"purple.webp"
]

var device_id: int = 0;

@onready var label: Label = $Vbox/Label
@onready var texture_rect: TextureRect = $Vbox/Texture


func set_portrait():
	texture_rect.texture = load("res://images/portraits/" + portrait_paths[device_id])


func _ready():
	set_device_id(get_index())
	print(device_id)
	set_portrait()

func set_device_id(id: int):
	device_id = id

func player_connected(color: String, id: int):
	set_device_id(id)
	var stylebox = StyleBoxFlat.new();
	stylebox.bg_color = Color.from_string(color, Color.BLACK)
	stylebox.corner_radius_bottom_left = 10
	self.add_theme_stylebox_override("panel", stylebox)
	label.text = "Player " + str(device_id + 1)
	
	

