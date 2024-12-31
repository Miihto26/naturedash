extends Node2D

# SET TO TRUE AND FALSE TO TOGGLE LEVEL EDITOR OR NOT
const in_edit_mode: bool = false

var current_level_name = "1-ENTER-EZRA"

# time it takes falling key to reach critical spot
var fk_fall_time: float = 1.875
var fk_output_arr = [[], []]

var level_info = {
	"1-ENTER-EZRA" = {
		"fk_times": "[[6.58577060699463, 7.38395690917969, 8.15311813354492, 9.76400184631348, 10.5650911331177, 11.3516664505005, 13.3485832214355, 14.1699886322021, 15.3542060852051, 15.7576522827148, 16.1523914337158, 16.8257713317871, 17.7748870849609, 19.72536277771, 20.5467681884766, 22.1692638397217, 22.9703521728516, 23.7801475524902, 26.1572895050049, 26.9583778381348, 28.1425971984863, 28.5808734893799, 28.9640026092529, 29.6780166625977, 30.5835952758789, 32.548583984375, 33.3786964416504, 34.9170188903809, 35.7587432861328, 36.5482215881348, 38.5625495910645, 39.3433227539063, 40.1328010559082, 41.1777000427246, 41.572437286377, 42.4257698059082], [4.94295930862427, 6.98050975799561, 7.72645092010498, 9.32572555541992, 10.1471319198608, 10.9482202529907, 12.9625511169434, 13.7520294189453, 14.5734348297119, 15.5660877227783, 15.9492168426514, 16.7183780670166, 16.9215526580811, 19.3219165802002, 20.1317119598389, 20.9531173706055, 22.5640029907227, 23.3737983703613, 24.1632766723633, 25.7422332763672, 26.5433216094971, 27.332799911499, 28.3457717895508, 28.7608280181885, 29.5822334289551, 29.7737979888916, 32.1422348022461, 32.9839553833008, 33.7734336853027, 35.3320732116699, 36.1534805297852, 36.9632759094238, 38.9485816955566, 39.7380599975586, 40.9106674194336, 41.3576545715332, 41.7640037536621, 42.306770324707, 42.4983329772949]]", #up and down times, respectively
		"music": load("res://music/1-EnterEzra.mp3")
	},
	
	"2-THIS-IS-MY-WORLD" = {
		"fk_times": "[[0],[1]]",
		"music": load("res://music/2-THISISMYWORLD.mp3")
	},
	
	"3-OUTTA-MY-WAY" = {
		"fk_times": "[[0],[1]]",
		"music": load("res://music/3-OuttaMyWay.mp3")
	},
	
	"4-GRAND-SLAM" = {
		"fk_times": "[[0],[1]]",
		"music": load("res://music/4-GRANDSLAM.mp3")
	},
	
	"5-LUNABLADE" = {
		"fk_times": "[[0],[1]]",
		"music": load("res://music/5-Lunablade.mp3")
	},
	
	"6-WHITE-WINGS-OF-WONDER" = {
		"fk_times": "[[0],[1]]",
		"music": load("res://music/6-WhiteWingsOfWonder.mp3")
	}
}


func _ready():
	Signals.StartLevel.connect(_on_StartLevel)
	print("CONNECTED START LEVEL SIGNAL")

func _on_StartLevel(level_name: String):
	print("STARTED")
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
		fk_output_arr = [[], []]
		Signals.KeyListenerPress.connect(KeyListenerPress)
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "button_up_smack"
				1:
					button_name = "button_down_smack"
			
			for delay in key:
				SpawnFallingKey(button_name, delay)
			
			counter += 1

func KeyListenerPress(button_name: String, array_num: int):
	print(str(array_num) + " " + str($MusicPlayer.get_playback_position()))
	fk_output_arr[array_num-1].append($MusicPlayer.get_playback_position() - fk_fall_time)

func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)

func _on_music_player_finished():
	print(fk_output_arr)
	Signals.FinishLevel.emit(current_level_name) 
