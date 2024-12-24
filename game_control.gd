extends Node2D

enum GameState { OVERWORLD, RHYTHM_GAME }

@onready var overworld_scene = preload("res://town.tscn")
@onready var rhythm_game_scene = preload("res://levels/game_level.tscn")

@onready var test_scene = preload("res://test_scene.tscn")

var current_state: GameState = GameState.OVERWORLD
var active_scene: Node

var game_test = null


func _ready():
	Signals.StartLevel.connect(_on_StartLevel)
	Signals.FinishLevel.connect(_on_FinishLevel)
	
	switch_to_overworld()
	
	game_test = test_scene.instantiate()
	add_child(game_test)
	print("Game started. Overworld loaded.")


func switch_to_overworld():
	if active_scene:
		active_scene.queue_free()
		
	print("Switching to Overworld")
	active_scene = overworld_scene.instantiate()
	add_child(active_scene)
	current_state = GameState.OVERWORLD

func switch_to_rhythm_game(level_name: String):
	if active_scene:
		active_scene.queue_free()
	
	print("Switching to Rhythm Game")
	active_scene = rhythm_game_scene.instantiate()
	add_child(active_scene)
	print("Instantiated Game Level")
	current_state = GameState.RHYTHM_GAME

func _on_StartLevel(level_name: String):
	switch_to_rhythm_game(level_name)

func _on_FinishLevel(level_name: String):
	switch_to_overworld()

