extends CharacterBody2D

@export var playerNum = 0
@export var moveSpeed:float = 400
@export var tackleSpeed:float = 16000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	var look_direction = Input.get_vector(
		"look_left", 
		"look_right",
		"look_up",
		"look_down")
	
	if Input.is_action_just_pressed("tackle"):
		velocity = look_direction * tackleSpeed
	else:
		velocity = input_direction * moveSpeed
	
	look_at(position + look_direction.normalized())

func _physics_process(delta):
	get_input()
	move_and_slide()
