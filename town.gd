extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
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
				allIndicators[i].hide()
			else:
				allIndicators[i].show()
				allIndicators[i].play("new")
		else:
			allNodes[i].hide()
			allIndicators[i].hide()
	#if all selected arent new then reshuffle
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
