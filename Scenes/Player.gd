extends RigidBody2D

@export var playerNum = 0
@export var moveSpeed:float = 900
@export var tackleSpeed:float = 1800

var playerMoveDirection = Vector2.ZERO
var playerLookDirection = Vector2.ZERO
var lookDirection = 0.0
var speedBoostSeconds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = 0.0
	lock_rotation = true
	GameGlobals.updateScore.connect(scoreUpdate)

func _physics_process(delta):
	playerMoveDirection = Input.get_vector("left", "right", "up", "down").normalized()
	playerLookDirection = Input.get_vector(
		"look_left", 
		"look_right",
		"look_up",
		"look_down"
	).normalized()
	
	$Node2D.look_at(position + playerLookDirection)

func _integrate_forces(state):
	state.apply_force(playerMoveDirection * moveSpeed)
	
	if Input.is_action_just_pressed("tackle"):
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

