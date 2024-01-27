extends Node

signal updateScore(playerNum,change)
signal updateCountdown
signal powerupTrigger(powerupType)

var playerScores = [0,0,0,0]
var playerColors: Array[String] = ['#00a700', '#ff604f', '#c0ac00', '#f67aff']
enum PlayerType { Player, CPU }
var countDown = 20

enum powerupType {SCORE,DUD,REVERSE_SCORE,SPEED_PLAYER,MUD,TELEPORT}
