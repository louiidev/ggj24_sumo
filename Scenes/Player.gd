extends RigidBody2D

@export var playerNum = 0
@export var moveSpeed:float = 900
@export var tackleSpeed:float = 1800
@export var deviceId = 0
@export var is_cpu = false

var playerMoveDirection = Vector2.ZERO
var playerLookDirection = Vector2.ZERO
var lookDirection = 0.0
var speedBoostSeconds = 0

var hasTackled: bool = false;


# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0.0
	lock_rotation = true
	GameGlobals.updateScore.connect(scoreUpdate)
	print_debug(Input.get_connected_joypads())


func _process(delta):
	if hasTackled && Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) <= 0:
		hasTackled = false

func init(device_id: int, is_computer: bool):
	deviceId = device_id
	is_cpu = is_computer

func look_follow(state: PhysicsDirectBodyState2D, current_transform: Transform2D, target_position: Vector2):
	var speed = 0.1
	var forward_local_axis: Vector2 = Vector2(1, 0)
	var forward_dir: Vector2 = (current_transform.basis_xform(forward_local_axis)).normalized()
	var target_dir: Vector2 = (target_position - current_transform.origin).normalized()
	var local_speed: float = clampf(speed, 0, acos(forward_dir.dot(target_dir)))
	if forward_dir.dot(target_dir) > 1e-4:
		state.angular_velocity = local_speed * forward_dir.cross(target_dir) / state.step

func joy_deadzone(axis: float, deadzone: float = 0.2):
	return axis if(!(axis < deadzone && axis > -deadzone)) else 0

func _physics_process(delta):
	playerLookDirection = Vector2(
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_RIGHT_X), 0.2),
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_RIGHT_Y), 0.2)
	)
	
	print_debug(playerLookDirection)
	playerMoveDirection = Vector2(
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_LEFT_X), 0.3),
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_LEFT_Y) ,0.3)
	)

func _integrate_forces(state):
	state.apply_force(playerMoveDirection * moveSpeed)
	
	if Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) > 0 && !hasTackled:
		hasTackled = true
		state.apply_impulse(Vector2.from_angle(rotation) * tackleSpeed)

func handlePowerup(powerupType):
	match powerupType:
		3: #SPEED_PLAYER
			speedBoostSeconds = 3
			
func scoreUpdate(playerNumIn, scoreIn):
	if(playerNum == playerNumIn):
		var scoreStr = str(scoreIn)
		if(scoreIn > 0):
			scoreStr = '+'+scoreStr
			$ScoreChange.set("theme_override_colors/font_color",Color(0.5,1,0.5))
		else:
			scoreStr = scoreStr
			$ScoreChange.set("theme_override_colors/font_color",Color(1,0.5,0.5))
		$ScoreChange.text = scoreStr
		$ScoreChange.visible = true
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($ScoreChange,"scale",Vector2(5,5),1)
		tween.tween_property($ScoreChange,"position",Vector2(-$ScoreChange.size.x*2.5,-200),1)
		tween.tween_property($ScoreChange,"visible",false,1)
		tween.connect('finished', scoreLabelReset)
		tween.play()

func scoreLabelReset():
	$ScoreChange.scale = Vector2(1,1)
	$ScoreChange.position = Vector2(0,-54)

