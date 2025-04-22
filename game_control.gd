extends Node2D

enum GameState { OVERWORLD, RHYTHM_GAME, END_CREDITS }

@onready var overworld_scene = preload("res://town.tscn")
@onready var rhythm_game_scene = preload("res://levels/game_level.tscn")
@onready var end_level_scene = preload("res://levels/end_level.tscn")
@onready var end_credits_scene = preload("res://end_credits.tscn")

@onready var test_scene = preload("res://test_scene.tscn")

var current_state: GameState = GameState.OVERWORLD
var active_scene: Node

var game_test = null

var prev_compassion = 0
var prev_connectivity = 0
var prev_ecoanxiety = 100


func _ready():
	Signals.StartLevel.connect(_on_StartLevel)
	Signals.FinishLevel.connect(_on_FinishLevel)
	
	switch_to_overworld()
	
	game_test = test_scene.instantiate()
	add_child(game_test)
	print("Game started. Overworld loaded.")
	
	DialogueManager.show_dialogue_balloon(load("res://dialogue/starting.dialogue"), "start")

func end_level():
	var level_score = 0
	var level_combo = 0
	if active_scene:
		if current_state == GameState.RHYTHM_GAME:
			Signals.LevelInfo[Signals.CurrentSong][0] = active_scene.find_child("GameUI").score
			Signals.LevelInfo[Signals.CurrentSong][1] = active_scene.find_child("GameUI").max_combo
			Signals.LevelInfo[Signals.CurrentSong][2] = active_scene.find_child("KeyListener").substats_ct
			for i in range(5):
				Signals.LevelInfo[Signals.CurrentSong][2][i] = Signals.LevelInfo[Signals.CurrentSong][2][i] + active_scene.find_child("KeyListener2").substats_ct[i]
		# end_level_scene.instance().setResults(active_scene.find_child("GameUI").score, active_scene.find_child("GameUI").max_combo)
		active_scene.queue_free()
		game_test.queue_free()
	print("End of level")
	
	if Signals.CurrentSong >= 6:  # Since arrays are 0-indexed, song 6 is at index 5
		switch_to_end_credits()
	else:
		active_scene = end_level_scene.instantiate()
		add_child(active_scene)
		game_test = test_scene.instantiate()
		add_child(game_test)
		current_state = GameState.OVERWORLD

func switch_to_overworld():
	if active_scene:
		print("DIE")
		active_scene.queue_free()
		
	print("Switching to Overworld")
	active_scene = overworld_scene.instantiate()
	add_child(active_scene)
	print(Signals.compassion)
	current_state = GameState.OVERWORLD

func switch_to_rhythm_game(level_name: String):
	if active_scene:
		print("DIE")
		active_scene.queue_free()
	
	print("Switching to Rhythm Game")
	active_scene = rhythm_game_scene.instantiate()
	add_child(active_scene)
	
	print("Instantiated Game Level")
	current_state = GameState.RHYTHM_GAME
	
	Signals.StartLevel.emit("") # this is just to make the level_editor work fsr

func switch_to_end_credits():
	if active_scene:
		active_scene.queue_free()
	
	if game_test:
		game_test.queue_free()
	
	print("Switching to End Credits")
	active_scene = end_credits_scene.instantiate()
	add_child(active_scene)
	current_state = GameState.END_CREDITS

func _on_StartLevel(level_name: String):
	if current_state != GameState.RHYTHM_GAME:
		switch_to_rhythm_game(level_name)

func _on_FinishLevel(level_name: String):
	if current_state == GameState.RHYTHM_GAME:
		for item in active_scene.find_child("KeyListener").falling_key_queue:
			if is_instance_valid(item): item.queue_free()
		for item in active_scene.find_child("KeyListener2").falling_key_queue:
			if is_instance_valid(item): item.queue_free()
		
		# Clear falling spikes
		for item in active_scene.find_child("KeyListener").falling_spikes_queue:
			if is_instance_valid(item): item.queue_free()
		for item in active_scene.find_child("KeyListener2").falling_spikes_queue:
			if is_instance_valid(item): item.queue_free()
		
		end_level()
	else:
		switch_to_overworld()
