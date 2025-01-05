extends Node2D

# progression bar vals
var compassion = 0
var connectivity = 0
var ecoanxiety = 100

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

var songs = ['1-ENTER-EZRA','2-THIS-IS-MY-WORLD','3-OUTTA-MY-WAY','4-GRAND-SLAM','5-LUNABLADE','6-WHITE-WINGS-OF-WONDER']
var CurrentSong: int=0
var LevelInfo = {
	0: [0,0,[0,0,0,0,0]],
	1: [0,0,[0,0,0,0,0]],
	2: [0,0,[0,0,0,0,0]],
	3: [0,0,[0,0,0,0,0]],
	4 : [0,0,[0,0,0,0,0]],
	5: [0,0,[0,0,0,0,0]]
}
