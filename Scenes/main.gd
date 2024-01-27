extends Node2D

var boundsRadius:float = 300

var powerup:PackedScene = preload('res://Scenes/Powerup.tscn')

@export var powerupsAtStart = 3
var player_scene: PackedScene = preload("res://Scenes/Player.tscn")
@onready var boundary: Node2D = $Boundry
@onready var boundaryShape:CollisionShape2D = $Boundry/StaticBody2D/CollisionShape2D
@onready var spawnPoints: Node2D = $Boundry/SpawnPoints
var players: Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for num in powerupsAtStart:
		addPowerup()
	GameGlobals.powerupTrigger.connect(handlePowerup)
	
	#if players.size() == 0:
		# FOR TESTING (REMOVE ONCE DONE)
		#add_player({ 'device_id': 0, 'is_real_player': true })
		#add_player({ 'device_id': 1, 'is_real_player': false })

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
	if(GameGlobals.countDown % 2 ==0):
		addPowerup()
	
	
func add_player(p):
	var player: Node2D = player_scene.instantiate()
	player.init(p['device_id'], p['is_real_player'])
	player.global_position = Vector2(50, 50)
	add_child(player)
	players.push_back(player)
	player.global_position = spawnPoints.get_child(p['device_id']).global_position
	
func init(playerData: Array):
	for p in playerData:
		add_player(p)
	
func _on_second_passed_timeout():
	secondPast()

func handlePowerup(typeIn):
	match typeIn:
		GameGlobals.powerupType.TELEPORT:
			for p in players:
				var r = boundsRadius * sqrt(randf())
				var theta = randf() * 2 * PI
				p.position.x = $Boundry.position.x + r * cos(theta)
				p.position.y = $Boundry.position.y + r * sin(theta)

