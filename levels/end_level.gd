extends Node2D

#@onready var game_control = preload("res://game_control.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	setResults(Signals.LevelInfo[Signals.CurrentSong][0],Signals.LevelInfo[Signals.CurrentSong][1])

func _on_retry_pressed():
	print("retry pressed")
	#couldnt figure out how to make these buttons work, maybe js create them in game_control
	#game_control.switch_to_rhythm_game(Signals.CurrentSong)

func _on_continue_pressed():
	print("continue pressed")
	#couldnt figure out how to make these buttons work, maybe js create them in game_control
	#game_control.switch_to_overworld()

func setResults(score, combo_count):
	$Control/CanvasLayer/ScoreLabel.text = "[center]Score: " + str(score) + "[/center]"
	$Control/CanvasLayer/ComboLabel.text = "[center]Max combo: " + str(combo_count) + "x[/center]"
