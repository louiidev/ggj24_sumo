extends Node2D

@export var scoreToAdd:int=5

var bodiesIn:Array
var bodiesScoring:Array
var reverseScoreTimes:float = 0

func _ready():
	GameGlobals.powerupTrigger.connect(handlePowerup)

func handlePowerup(powerupType):
	match powerupType:
		GameGlobals.powerupType.REVERSE_SCORE: #reverse score
			reverseScoreTimes = 3
			$ScoreBoundryImage.modulate = Color(1,0.5,0.5)

func sumoEntered(bodyIn):
	if(bodiesIn.find(bodyIn) == -1):
		bodiesIn.push_back(bodyIn)
		print(bodiesIn)
	
func sumoExited(bodyOut):
	var fIdx = bodiesIn.find(bodyOut)
	if(fIdx != -1):
		bodiesIn.remove_at(fIdx)
	fIdx = bodiesScoring.find(bodyOut)
	if(fIdx != -1):
		bodiesScoring.remove_at(fIdx)

func scoreNow():
	var score = scoreToAdd
	if(reverseScoreTimes > 0):
		score = scoreToAdd * -2
		reverseScoreTimes -= 1
		if(reverseScoreTimes < 1):
			$ScoreBoundryImage.modulate = Color(1,1,1)
	
	for body in bodiesScoring:
		print(body.deviceId, "DEVICE ID")
		GameGlobals.playerScores[body.deviceId] += score
		GameGlobals.updateScore.emit(body.deviceId, score)
	bodiesScoring = bodiesIn
