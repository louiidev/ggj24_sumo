extends Control

var scoreLabels:Array

var winner

# Called when the node enters the scene tree for the first time.
func _ready():
	scoreLabels = $UI/Scores/MarginContainer/Bottom/MarginContainer/Scores.get_children()
	var winnerScore = 0
	for idx in range(0,4):
		scoreLabels[idx].text = str(GameGlobals.playerScores[idx])
		if(GameGlobals.playerScores[idx] > winnerScore):
			winner = idx
			winnerScore = GameGlobals.playerScores[idx]
	
	var winnerImgFile = "green.jpg"
	match winner:
		1:
			winnerImgFile = "red.webp"
		2:
			winnerImgFile = "yellow.jpg"
		3:
			winnerImgFile = "purple.webp"
	var winnertexture:Texture = load("res://images/portraits/" + winnerImgFile)
	$UI/Scores/MarginContainer/Bottom/HBoxContainer/TextureRect.texture = winnertexture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		restart()

func restart():
	get_tree().change_scene_to_file("res://Scenes/Lobby.tscn")
	GameGlobals.reset()
