extends Node2D

var boundsRadius:float = 300

var powerup:PackedScene = preload('res://Scenes/Powerup.tscn')

@export var powerupsAtStart = 3
var player_scene: PackedScene = preload("res://Scenes/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for num in powerupsAtStart:
		addPowerup()

func addPowerup():
	var r = boundsRadius * sqrt(randf())
	var theta = randf() * 2 * PI
	
	var newPowerup = powerup.instantiate()
	newPowerup.position.x = $Boundry.position.x + r * cos(theta)
	newPowerup.position.y = $Boundry.position.y + r * sin(theta)
	
	add_child(newPowerup)
	
func secondPast():
	GameGlobals.countDown -= 1
	GameGlobals.updateCountdown.emit()
	if(GameGlobals.countDown % 5 ==0):
		addPowerup()
	
	
func init():
	
	pass


func _on_second_passed_timeout():
	secondPast()
	pass # Replace with function body.
