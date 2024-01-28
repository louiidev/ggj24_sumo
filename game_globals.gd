extends Node

signal updateScore(playerNum,change)
signal updateCountdown
signal powerupTrigger(powerupType)

signal shakeCamera(amount: int)

var playerScores = [0,0,0,0]
var playerColors: Array[String] = ['#00a700', '#ff604f', '#c0ac00', '#f67aff']
enum PlayerType { Player, CPU }
var countDown = 20

enum powerupType {SCORE,DUD,REVERSE_SCORE,SPEED_PLAYER,MUD,TELEPORT}


var players: Array[Node2D] = []

func set_player(p: Node2D):
	players.push_back(p)
