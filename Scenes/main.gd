extends Node2D

var boundsRadius:float = 300

var powerup:PackedScene = preload('res://Scenes/Powerup.tscn')

# Called when the node enters the scene tree for the first time.
func _ready():
	addPowerup()
	addPowerup()
	addPowerup()

func addPowerup():
	var r = boundsRadius * sqrt(randf())
	var theta = randf() * 2 * PI
	
	var newPowerup = powerup.instantiate()
	newPowerup.position.x = $Boundry.position.x + r * cos(theta)
	newPowerup.position.y = $Boundry.position.y + r * sin(theta)
	
	add_child(newPowerup)
	
