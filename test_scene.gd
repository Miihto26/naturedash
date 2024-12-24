extends Control

func _ready():
	
	# testing game states
	var start_button = Button.new()
	start_button.text = "Start Rhythm Game"
	start_button.pressed.connect(_on_start_button_pressed)
	add_child(start_button)
	
	var finish_button = Button.new()
	finish_button.text = "Return to Overworld"
	finish_button.pressed.connect(_on_finish_button_pressed)
	add_child(finish_button)
	
	start_button.position.y = 200
	finish_button.position.y = 250

func _on_start_button_pressed():
	Signals.StartLevel.emit("1-ENTER-EZRA")
	
func _on_finish_button_pressed():
	Signals.FinishLevel.emit("1-ENTER-EZRA")
