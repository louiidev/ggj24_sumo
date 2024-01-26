extends CanvasLayer

var scoreLabels:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	GameGlobals.updateScore.connect(updateScore)
	scoreLabels = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func updateScore(playerNum):
	scoreLabels[playerNum].text = str(GameGlobals.playerScores[playerNum])
	
