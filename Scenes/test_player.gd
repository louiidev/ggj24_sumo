extends CharacterBody2D

@export var playerNum = 0
const MAXSPEED = 500.0

func _physics_process(delta):
	velocity.x = delta * MAXSPEED
	move_and_slide()
