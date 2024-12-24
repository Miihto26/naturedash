extends Node2D

# SET TO TRUE AND FALSE TO TOGGLE LEVEL EDITOR OR NOT
const in_edit_mode: bool = false

var current_level_name = "1-ENTER-EZRA"

# time it takes falling key to reach critical spot
var fk_fall_time: float = 1.875
var fk_output_arr = [[], []]

var level_info = {
	"1-ENTER-EZRA" = {
		"fk_times": "[[4.84717702865601, 6.52191638946533, 7.31139469146729, 8.10958003997803, 9.31701850891113, 10.0948867797852, 10.8843650817871, 12.9103059768677, 13.7113943099976, 14.5647277832031, 15.502233505249, 15.9288997650146, 16.7067680358887, 16.8780155181885, 17.7197399139404, 19.6731185913086, 20.4945240020752, 22.0937976837158, 22.9035949707031, 23.704683303833, 25.7103061676025, 26.5433216094971, 27.3415088653564, 28.3341617584229, 28.7405109405518, 29.5386962890625, 29.7099437713623, 30.4878120422363, 32.0464515686035, 32.8881759643555, 33.753116607666, 34.893798828125, 35.6948852539063, 36.5162925720215, 38.4145240783691, 39.3201026916504, 40.1647262573242, 40.9106674194336, 41.3373374938965, 41.7320747375488, 42.3183784484863, 42.4896240234375], [6.87311744689941, 7.67420673370361, 9.67982959747314, 10.4576988220215, 11.2878122329712, 13.2615079879761, 14.0945234298706, 15.2787418365479, 15.7170181274414, 16.1204643249512, 16.8344783782959, 19.2899894714355, 20.0794677734375, 20.9415073394775, 22.4769268035889, 23.309944152832, 24.099422454834, 26.1050453186035, 26.9148406982422, 28.110668182373, 28.5489463806152, 28.9436855316162, 29.6460876464844, 32.4411888122559, 33.3061332702637, 35.3117561340332, 36.0896263122559, 36.8791046142578, 38.873119354248, 39.7380599975586, 41.134162902832, 41.5492172241211, 42.4141616821289]]", #up and down times, respectively
		"music": load("res://music/1-EnterEzra.mp3")
	}
}


func _ready():
	
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
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
	#print(str(array_num) + " " + str($MusicPlyaer.get_playback_position()))
	fk_output_arr[array_num-1].append($MusicPlayer.get_playback_position() - fk_fall_time)

func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)

func _on_music_player_finished():
	print(fk_output_arr)
