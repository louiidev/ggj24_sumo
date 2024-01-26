extends Node2D

@export var scoreToAdd:int=5

var bodiesIn:Array
var bodiesScoring:Array

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
	for body in bodiesScoring:
		GameGlobals.playerScores[body.playerNum] += scoreToAdd
		GameGlobals.updateScore.emit(body.playerNum)
	bodiesScoring = bodiesIn
