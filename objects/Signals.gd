extends Node2D

# rhythm game signals
signal IncrementScore(incr: int)

signal IncrementCombo()
signal ResetCombo()

signal CreateFallingKey(button_name: String)
signal KeyListenerPress(button_name: String, array_num: int)


# game state signals
signal StartLevel(level_name: String)
signal FinishLevel(level_name: String)

var inDialogue = false

var CurrentSong = '1-ENTER-EZRA'
var LevelInfo = {
	'1-ENTER-EZRA': [0,0,[0,0,0,0,0]],
	'2-THIS-IS-MY-WORLD': [0,0,[0,0,0,0,0]],
	'3-OUTTA-MY-WAY': [0,0,[0,0,0,0,0]],
	'4-GRAND-SLAM': [0,0,[0,0,0,0,0]],
	'5-LUNABLADE' : [0,0,[0,0,0,0,0]],
	'6-WHITE-WINGS-OF-WONDER': [0,0,[0,0,0,0,0]]
}
