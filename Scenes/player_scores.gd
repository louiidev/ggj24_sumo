extends CanvasLayer

var scoreLabels:Array

# Called when the node enters the scene tree for the first time.
func _ready():
	GameGlobals.updateScore.connect(updateScore)
	scoreLabels = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer.get_children()
	GameGlobals.updateCountdown.connect(updateCountdown)
	$MarginContainer/HBoxContainer/TimeRemaining.text = str(GameGlobals.countDown)

func updateScore(playerNum, _changeIn):
	scoreLabels[playerNum].text = str(GameGlobals.playerScores[playerNum])
	
func updateCountdown():
	$MarginContainer/HBoxContainer/TimeRemaining.text = str(GameGlobals.countDown)
	$TickSound.play()
	if(GameGlobals.countDown < 11):
		$MarginContainer/HBoxContainer/TimeRemaining.set("theme_override_colors/font_color",Color(1,0.5,0.5))
		if(GameGlobals.countDown % 2 == 0):
			$MarginContainer/HBoxContainer/TimeRemaining.set("theme_override_font_sizes/font_size",42)
		else:
			$MarginContainer/HBoxContainer/TimeRemaining.set("theme_override_font_sizes/font_size",36)

