extends BaseDialogueTestScene

func _ready() -> void:
	var balloon = load("res://dialogue/dialogue balloon/balloon.tscn").instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(resource, title)
	#DialogueManager.show_dialogue_balloon(load("res://dialogue"))
