extends Node

enum { PLAYER_1 = 0, PLAYER_2 = 1, PLAYER_3 = 2, PLAYER_4 = 3}

var players_joined: Array[bool] = [false, false, false, false]
var player_select_item = preload("res://Scenes/PlayerSelectItem.tscn")

@onready var UI: Control = $UI
@onready var PlayerSelectContainer: Control = $UI/PlayerSelectContainer
@onready var game_globals = get_node("/root/GameGlobals")

signal on_player_connected(device_id: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.connect("joy_connection_changed", _joy_connection_changed)
	
	for i in players_joined.size():
		var node: Panel = player_select_item.instantiate()
		if is_instance_valid(node):
			node.player_connected(game_globals.playerColors[i])
			PlayerSelectContainer.add_child(node)
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	handle_controller_input()
	

func join_player(device: int):
	players_joined[device] = true
	on_player_connected.emit(device)


func handle_controller_input():
	for i in players_joined.size():
		var player = players_joined[i]
		if not player:
			if Input.is_joy_known(i) and Input.is_joy_button_pressed(i, JOY_BUTTON_START):
				join_player(i)

func _joy_connection_changed(device: int, connected: bool):
	print(str(device)+" "+str(connected))
	#if connected:
		#spawn_player(device)
	#else:
		#despawn_player(device)
	#pass


#func despawn_player(device: int):
	#players_joined[device] = false;
	#match device:
		#PLAYER_1:
			#player.instantiate()
			#print("player 1")
		#PLAYER_2:
			#player.instantiate()
			#print("player 2")
		#PLAYER_3:
			#player.instantiate()
			#print("player 3")
		#PLAYER_4:
			#player.instantiate()
			#print("player 4")
	#pass
	

#func spawn_player(device: int):
	#players_joined[device] = player.instantiate()
	#add_child(players[device])
	#match device:
		#PLAYER_1:
			#player1 = player.instantiate()
			#add_child(player1)
			#print("player 1")
		#PLAYER_2:
			#player2 = player.instantiate()
			#add_child(player1)
			#print("player 2")
		#PLAYER_3:
			#player.instantiate()
			#print("player 3")
		#PLAYER_4:
			#player.instantiate()
			#print("player 4")
