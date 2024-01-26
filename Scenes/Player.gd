extends CharacterBody2D

@export var speed = 400

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var look_direction = Input.get_vector("look_down","look_up","look_left", "look_right")
	velocity = input_direction * speed
	look_at(position + look_direction.normalized())

func _physics_process(delta):
	get_input()
	move_and_slide()
