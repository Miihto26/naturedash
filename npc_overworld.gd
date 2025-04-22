extends Sprite2D

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)) and not Signals.inDialogue:
			DialogueManager.show_dialogue_balloon(load("res://dialogue/starting.dialogue"), self.name)
			var nodeName = self.name
			Signals.npcInteracted[String(nodeName)[4].to_int()-1] = 1
			get_parent().get_node("Indicator" + String(nodeName)[4]).hide()
			if String(nodeName)[4].to_int() <=2:
				incCompassion()
			else:
				incConnectivity()
			decEcoAnxiety()

func incCompassion():
	Signals.compassion = Signals.compassion + 20
	while get_parent().get_node("ProgressionBars").get_node("compassion").value != Signals.compassion:
		await get_tree().create_timer(0.1).timeout
		get_parent().get_node("ProgressionBars").get_node("compassion").value += 1

func incConnectivity():
	Signals.connectivity = Signals.connectivity + 20
	while get_parent().get_node("ProgressionBars").get_node("connectivity").value != Signals.connectivity: 
		await get_tree().create_timer(0.1).timeout
		get_parent().get_node("ProgressionBars").get_node("connectivity").value += 1

func decEcoAnxiety():
	Signals.ecoanxiety = Signals.ecoanxiety - 20
	while get_parent().get_node("ProgressionBars").get_node("ecoanxiety").value != Signals.ecoanxiety:
		await get_tree().create_timer(0.1).timeout
		get_parent().get_node("ProgressionBars").get_node("ecoanxiety").value -= 1
