extends RigidBody2D

@export var playerNum = 0
@export var moveSpeed:float = 900
@export var tackleSpeed:float = 1800

var playerMoveDirection = Vector2.ZERO
var playerLookDirection = Vector2.ZERO
var lookDirection = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0.0

func _process(delta):
	playerMoveDirection = Input.get_vector("left", "right", "up", "down").normalized()
	playerLookDirection = Input.get_vector(
		"look_left", 
		"look_right", 
		"look_up", 
		"look_down"
	).normalized()

func _integrate_forces(state):
	state.apply_force(playerMoveDirection * moveSpeed)

	#var rotation_direction = Input.get_axis("look_left", "look_right")
	
	
	#state.angular_velocity += rotation_direction * 300
	#
	if Input.is_action_just_pressed("tackle"):
		state.apply_impulse(playerLookDirection * tackleSpeed)
	
