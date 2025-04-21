extends Node2D

# SET TO TRUE AND FALSE TO TOGGLE LEVEL EDITOR OR NOT
const in_edit_mode: bool = false

var current_level_name = Signals.songs[Signals.CurrentSong]

@onready var background_manager_scene = preload("res://art/backgrounds/BackgroundManager.tscn")
var current_background: Node = null

# time it takes falling key to reach critical spot
var fk_fall_time: float = 1.875
var fk_output_arr = [[], []]

var level_info = {
	"1-ENTER-EZRA" = {
		"fk_times": "[[4.70785713195801, 7.08500003814697, 9.49697303771973, 11.1281747817993, 13.4849996566772, 17.4759292602539, 19.9082202911377, 22.3085823059082, 23.8875389099121, 26.2762928009033, 30.2759284973145, 32.6762924194336, 35.0766563415527, 36.7078590393066, 39.0849990844727], [6.23166656494141, 7.89769840240479, 10.2980613708496, 12.7071313858032, 14.2744789123535, 15.0755672454834, 15.89697265625, 16.6980609893799, 19.098424911499, 20.6744785308838, 23.0980606079102, 25.4984245300293, 27.0744781494141, 27.8755664825439, 28.7085819244385, 29.5067691802979, 31.8752021789551, 33.474479675293, 35.8980598449707, 38.275203704834, 39.9064064025879, 40.7074928283691, 41.4766540527344, 42.2980613708496]]", #up and down times, respectively
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
	
	load_level_background(current_level_name)
	
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
	
	if current_background:
		current_background.queue_free()
	
	Signals.CurrentSong += 1
	Signals.FinishLevel.emit(current_level_name) 

func load_level_background(level_name: String):
	print("Loaded Background")
	# Create background manager
	current_background = background_manager_scene.instantiate()
	add_child(current_background)
	
	if current_level_name == "1-ENTER-EZRA":
		current_background.scale_factor = 3.0
		current_background.centered = true
		current_background.offset = Vector2(0, 0)
	elif current_level_name == "2-THIS-IS-MY-WORLD":
		current_background.scale_factor = 3.0
		current_background.centered = true
		current_background.offset = Vector2(0, 125)
	elif current_level_name == "3-OUTTA-MY-WAY":
		current_background.scale_factor = 5.0
		current_background.centered = true
		current_background.offset = Vector2(0, 0)
	elif current_level_name == "4-GRAND-SLAM":
		current_background.scale_factor = 5.0
		current_background.centered = true
		current_background.offset = Vector2(0, 0)
	elif current_level_name == "5-LUNABLADE":
		current_background.scale_factor = 3.0
		current_background.centered = true
		current_background.offset = Vector2(0, 0)
	elif current_level_name == "6-WHITE-WINGS-OF-WONDER":
		current_background.scale_factor = 4.0
		current_background.centered = true
		current_background.offset = Vector2(50, 150)
	
	# Tell it which level to show background for
	current_background.set_level(current_level_name)
	
	await get_tree().create_timer(0.5).timeout  # Give it time to load
	current_background.print_debug_info()
