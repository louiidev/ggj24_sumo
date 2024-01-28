extends RigidBody2D

@export var moveSpeed:float = 900
@export var tackleSpeed:float = 1800
@export var deviceId = 0
@export var is_player = false

var tackledPressedInFrame = false
var tackleDirection = Vector2.ZERO

var canAttack = true
var playerMoveDirection = Vector2.ZERO
var playerLookDirection = Vector2.ZERO
var lookDirection = 0.0
var speedBoostSeconds = 0
var stuckBoostSeconds = 0

var attackLerpTime = 0.05

var handRestLocalPosition = Vector2(150, 0)
var handAttackLocalPosition = Vector2(100, -100)

var faceRestScale = Vector2.ONE
var faceAttackScale = Vector2(0.85, 1)

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

@onready var body_sprite: Sprite2D = $Node2D/Body
@onready var right_hand: Sprite2D = $Node2D/RightHand
@onready var left_hand: Sprite2D = $Node2D/LeftHand
@onready var face: Sprite2D = $Node2D/Face

@onready var attack_particle: CPUParticles2D = $AttackParticle
@onready var hit_particle: CPUParticles2D = $HitParticle

var hit_face: Texture;
var attack_face: Texture;
var original_face: Texture;
var local_collision_pos: Vector2

# AI 
var ai_target: Node2D = null;
var ai_timer: Timer = Timer.new()
var AI_ATTACK_RANGE = 150.0

func set_sprite():

	body_sprite.texture = load("res://Assets/" + portrait_paths[deviceId] + "_body_circle.png")

	var hand_texture = load("res://Assets/" + portrait_paths[deviceId] + "_hand_closed.png")
	
	right_hand.texture = hand_texture
	left_hand.texture = hand_texture
	
	var face_texture = load("res://Assets/faces/face_" + faces[deviceId] + ".png")
	face.texture = face_texture
	original_face = face_texture
	
	hit_face = load("res://Assets/faces/face_j.png")
	attack_face = load("res://Assets/faces/face_f.png")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0.0
	GameGlobals.updateScore.connect(scoreUpdate)
	set_sprite()
	GameGlobals.updateCountdown.connect(tickProcess)
	GameGlobals.powerupTrigger.connect(handlePowerup)

func _process(delta):
	if hasTackled && Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) <= 0:
		hasTackled = false
		
	if Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) <= 0:
		onStopAttack()
	
	if is_player:
		tackledPressedInFrame = Input.get_joy_axis(deviceId, JOY_AXIS_TRIGGER_RIGHT) > 0 && !hasTackled && canAttack
		tackleDirection = Vector2.from_angle(rotation)

func init(device_id: int, is_real_player: bool):
	deviceId = device_id
	is_player = is_real_player

func joy_deadzone(axis: float, deadzone: float = 0.2):
	return axis if(!(axis < deadzone && axis > -deadzone)) else 0

func _physics_process(delta):
	if !is_player:
		ai_update()
		return
	
	playerLookDirection = Vector2(
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_RIGHT_X), 0.2),
		joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_RIGHT_Y), 0.2)
	)
	
	if !stunned:
		playerMoveDirection = Vector2(
			joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_LEFT_X), 0.3),
			joy_deadzone(Input.get_joy_axis(deviceId, JOY_AXIS_LEFT_Y) ,0.3)
		)
	
	if(!stunned):
		look_at(position + playerLookDirection)
	
	if($Labels/ScoreChange.visible): #If visible score labe should be rotated up
		$Labels.rotation = rotation * -1
		
func tackle(state):
	if stunned:
		return
	
	get_node("AttackTimer").start()
	canAttack = false
	hasTackled = true
	state.apply_impulse(tackleDirection * tackleSpeed)
	tackledPressedInFrame = false
	attack_particle.emitting = true
	$Attack.play()

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Node2D/Body,"scale", faceAttackScale, attackLerpTime)
	tween.tween_property($Node2D/LeftHand,"position", handAttackLocalPosition, attackLerpTime)
	tween.tween_property($Node2D/RightHand,"position", handAttackLocalPosition * Vector2.LEFT, attackLerpTime)
	tween.play()
	
	face.texture = attack_face
	
func onStopAttack(): 
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property($Node2D/Body,"scale", faceRestScale, attackLerpTime)
	tween.tween_property($Node2D/LeftHand,"position", handRestLocalPosition, attackLerpTime)
	tween.tween_property($Node2D/RightHand,"position", handRestLocalPosition * Vector2.LEFT, attackLerpTime)
	tween.play()
	
	face.texture = original_face

func _integrate_forces(state):
	var boostMultiplier = 1
	if(speedBoostSeconds > 0):
		boostMultiplier = boostMultiplier * 2.5
	if(stuckBoostSeconds > 0):
		boostMultiplier = boostMultiplier * 0.4
	state.apply_force(playerMoveDirection * moveSpeed * boostMultiplier)
	
	if tackledPressedInFrame:
		tackle(state)

	if(state.get_contact_count() >= 1): 
		local_collision_pos = state.get_contact_local_position(0)

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
	onStopAttack()
	
func tickProcess():
	if(speedBoostSeconds > 0):
		speedBoostSeconds -=1
	if(stuckBoostSeconds > 0):
		stuckBoostSeconds -=1

func onCollision(_bodyIn):
	$Collision.play()

func _on_body_entered(body):
	if body.get_script() != null:
		# Turn off attack particle on hit
		attack_particle.emitting = false
		if !body.canAttack and canAttack:
			face.texture = hit_face
			stunned = true
			
			var collision_position = local_collision_pos
			hit_particle.position = collision_position
			hit_particle.emitting = true
			
			GameGlobals.shakeCamera.emit(0.4)
			await get_tree().create_timer(1.0).timeout
			face.texture = original_face
			stunned = false
			ai_target = null
			
			
			
func find_players() -> Array[Node2D]:
	return GameGlobals.players
	
func find_target():
	var players = find_players()
	var closest: float = INF
	for p in players:
		if p.get_instance_id() == self.get_instance_id():
			continue
		
		if p.global_position.distance_to(self.global_position) < closest:
			closest = p.global_position.distance_to(self.global_position)
			print("PLAYER target" + str(p.deviceId))
			ai_target = p
	
	

			
func ai_update():
	if ai_target == null:
		find_target()
	
	
	var direction = (ai_target.global_position - global_position).normalized()
	playerMoveDirection = direction
	if canAttack and ai_target.global_position.distance_to(self.global_position) <= AI_ATTACK_RANGE:
		tackledPressedInFrame = true
		tackleDirection = playerMoveDirection
		ai_target = null
		playerMoveDirection = Vector2.ZERO
		
			
		
			
