extends RigidBody2D

@export var moveSpeed:float = 900
@export var tackleSpeed:float = 1800
@export var deviceId = 0
@export var is_player = false

var canAttack = true
var playerMoveDirection = Vector2.ZERO
var playerLookDirection = Vector2.ZERO
var lookDirection = 0.0
var speedBoostSeconds = 0
var stuckBoostSeconds = 0

var hasTackled: bool = false
var stunned: bool = false

var portrait_paths = [
	"green",
	"red",
	"yellow",
	"purple"
]

var faces = [
	"c",
	"e",
	"g",
	"i",
	"j"
]

@onready var body: Sprite2D = $Node2D/Body
@onready var right_hand: Sprite2D = $Node2D/RightHand
@onready var left_hand: Sprite2D = $Node2D/LeftHand
@onready var face: Sprite2D = $Node2D/Face

var hit_face: Texture;
var original_face: Texture;

func set_sprite():
	var body_image = Image.load_from_file("res://Assets/" + portrait_paths[deviceId] + "_body_circle.png")
	var body_texture = ImageTexture.create_from_image(body_image)
	body.texture = body_texture
	
	var hand_image = Image.load_from_file("res://Assets/" + portrait_paths[deviceId] + "_hand_closed.png")
	var hand_texture = ImageTexture.create_from_image(hand_image)
	right_hand.texture = hand_texture
	left_hand.texture = hand_texture
	
	var face_image = Image.load_from_file("res://Assets/faces/face_" + faces[deviceId] + ".png")
	var face_texture = ImageTexture.create_from_image(face_image)
	face.texture = face_texture
	original_face = face_texture
	
	var hit_face_image = Image.load_from_file("res://Assets/faces/face_j.png")
	hit_face = ImageTexture.create_from_image(hit_face_image)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0.0
	lock_rotation = true
	GameGlobals.updateScore.connect(scoreUpdate)
	set_sprite()
	GameGlobals.updateCountdown.connect(tickProcess)
	GameGlobals.powerupTrigger.connect(handlePowerup)

func _process(delta):
	if !is_player:
		return
	if hasTackled && Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) <= 0:
		hasTackled = false

func init(device_id: int, is_real_player: bool):
	deviceId = device_id
	is_player = is_real_player

func joy_deadzone(axis: float, deadzone: float = 0.2):
	return axis if(!(axis < deadzone && axis > -deadzone)) else 0

func _physics_process(delta):
	if !is_player:
		return
	playerLookDirection = Vector2(
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_RIGHT_X), 0.2),
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_RIGHT_Y), 0.2)
	)
	
	playerMoveDirection = Vector2(
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_LEFT_X), 0.3),
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_LEFT_Y) ,0.3)
	)
	
	look_at(position + playerLookDirection)
	
	if($Labels/ScoreChange.visible): #If visible score labe should be rotated up
		$Labels.rotation = rotation * -1

func _integrate_forces(state):
	if !is_player or stunned:
		return
	var boostMultiplier = 1
	if(speedBoostSeconds > 0):
		boostMultiplier = boostMultiplier * 2.5
	if(stuckBoostSeconds > 0):
		boostMultiplier = boostMultiplier * 0.4
	state.apply_force(playerMoveDirection * moveSpeed * boostMultiplier)
	

	if !stunned and Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) > 0 && !hasTackled && canAttack:
		get_node("AttackTimer").start()
		canAttack = false
		hasTackled = true
		state.apply_impulse(Vector2.from_angle(rotation) * tackleSpeed)

func handlePowerup(powerupType):
	match powerupType:
		GameGlobals.powerupType.SPEED_PLAYER:
			speedBoostSeconds = 5
		GameGlobals.powerupType.MUD:
			stuckBoostSeconds = 5
			
func scoreUpdate(playerNumIn, scoreIn):
	if(deviceId == playerNumIn):
		var scoreStr = str(scoreIn)
		if(scoreIn > 0):
			scoreStr = '+'+scoreStr
			$Labels/ScoreChange.set("theme_override_colors/font_color",Color(0.5,1,0.5))
		else:
			scoreStr = scoreStr
			$Labels/ScoreChange.set("theme_override_colors/font_color",Color(1,0.5,0.5))
		$Labels/ScoreChange.text = scoreStr
		$Labels/ScoreChange.visible = true
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($Labels/ScoreChange,"scale",Vector2(5,5),1)
		tween.tween_property($Labels/ScoreChange,"position",Vector2(-$Labels/ScoreChange.size.x*2.5,-200),1)
		tween.tween_property($Labels/ScoreChange,"visible",false,1)
		tween.connect('finished', scoreLabelReset)
		tween.play()

func scoreLabelReset():
	$Labels/ScoreChange.scale = Vector2(1,1)
	$Labels/ScoreChange.position = Vector2(0,-54)

func _on_attack_timer_timeout():
	canAttack = true
	
func tickProcess():
	if(speedBoostSeconds > 0):
		speedBoostSeconds -=1
	if(stuckBoostSeconds > 0):
		stuckBoostSeconds -=1



func _on_body_entered(body):
	if body.get_script() != null:
		if !body.canAttack and canAttack:
			face.texture = hit_face
			stunned = true
			
			await get_tree().create_timer(1.0).timeout
			face.texture = original_face
			stunned = false
			
