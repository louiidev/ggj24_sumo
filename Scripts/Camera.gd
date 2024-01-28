extends Camera2D


@export var random_strength = 30.0;
@export var shake_fade = 5.0;

var rnd = RandomNumberGenerator.new()

var shake_strength = 0.0

func _ready():
	GameGlobals.shakeCamera.connect(apply_shake)
	
	
	
func _process(delta):
	if shake_strength > 0:
		print("SHAKE")
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		offset = random_offset()
	
func random_offset() -> Vector2:
	return Vector2(rnd.randf_range(-shake_strength, shake_strength), rnd.randf_range(-shake_strength, shake_strength))
	
	
func apply_shake(amount: float):
	print("APPLY SHAKE")
	shake_strength = random_strength * amount
	pass
