extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(Signals.ecoanxiety)
	$AudioStreamPlayer2D.stream = load("res://music/A Town of Your Dreams.mp3")
	$AudioStreamPlayer2D.play()
	#too lazy rn but make this apply to both positive or negative changes in future
	randomize()
	var listIcons = [0,1,2,3,4]
	listIcons.shuffle()
	var selectedItems = [listIcons[0], listIcons[1]]
	print(selectedItems)
	var allNodes = [get_node("Icon1"), get_node("Icon2"),get_node("Icon3"),get_node("Icon4"),get_node("Icon5")]
	var allIndicators = [get_node("Indicator1"), get_node("Indicator2"),get_node("Indicator3"),get_node("Indicator4"),get_node("Indicator5")]
		
	for i in range(len(allNodes)):
		if i in selectedItems:
			allNodes[i].show()
			if Signals.npcInteracted[i] == 1:
				allIndicators[i].show()
				allIndicators[i].play("completed")
			else:
				allIndicators[i].show()
				allIndicators[i].play("new")
		else:
			allNodes[i].hide()
			allIndicators[i].hide()
	#if all selected arent new then reshuffle TODO
	
	get_node("ProgressionBars").get_node("compassion").value = 0
	get_node("ProgressionBars").get_node("connectivity").value = 0
	get_node("ProgressionBars").get_node("ecoanxiety").value = 100
	while get_node("ProgressionBars").get_node("compassion").value != Signals.compassion:
		await get_tree().create_timer(0.05).timeout
		get_node("ProgressionBars").get_node("compassion").value += 1
	while get_node("ProgressionBars").get_node("connectivity").value != Signals.connectivity: 
		await get_tree().create_timer(0.05).timeout
		get_node("ProgressionBars").get_node("connectivity").value += 1
	while get_node("ProgressionBars").get_node("ecoanxiety").value != Signals.ecoanxiety:
		await get_tree().create_timer(0.05).timeout
		get_node("ProgressionBars").get_node("ecoanxiety").value -= 1
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_viewport().get_mouse_position()[0] < 50:
		if global_position.x < 25:
			global_position.x += 2
	elif get_viewport().get_mouse_position()[0] > 1050:
		if global_position.x > -25:
			global_position.x -= 2
	else:
		if global_position.x != -17 or global_position.x != -18 or global_position.x != -16:
			if global_position.x < -17:
				global_position.x += 2
			elif global_position.x > -17:
				global_position.x -= 2
			
	if get_viewport().get_mouse_position()[1] < 50:
		if global_position.y < 15:
			global_position.y += 2
	elif get_viewport().get_mouse_position()[1] > 600:
		if global_position.y > -15:
			global_position.y -= 2
	else:
		if global_position.y != -8 or global_position.y != -7 or global_position.y != -6:
			if global_position.y < -8:
				global_position.y += 2
			elif global_position.y > -8:
				global_position.y -= 2
	await get_tree().create_timer(0.1).timeout
		
	pass
