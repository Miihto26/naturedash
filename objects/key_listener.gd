extends Sprite2D

@onready var falling_key = preload("res://objects/falling_key.tscn")
@onready var falling_spikes = preload("res://objects/falling_spikes.tscn")
@onready var score_text = preload("res://objects/score_press_text.tscn")
@export var key_name: String = ""

var falling_key_queue = []
var falling_spikes_queue = []

var perfect_press_threshold: float = 55
var great_press_threshold: float = 70
var good_press_threshold: float = 100
var ok_press_threshold: float = 120

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20
var spike_penalty: float = -150

var ktp_idx = 0
var spike_idx = 0

var substats_ct = [0,0,0,0,0]

var is_jumping = false
var jump_velocity = -100
var current_jump_velocity = 0
var gravity = 150
var base_y_position = 225

var animation_offsets = {
	"run": Vector2(0, 0),
	"upward": Vector2(0, 0),
	"fall": Vector2(0, 20),
	"downward": Vector2(0, 0),
	"low_punch": Vector2(0, 0),
	"up_punch": Vector2(0, 0)
}


func _ready():
	$GlowOverlay.frame = frame + 4
	get_parent().get_node("AnimatedSprite2D").play("run")
	Signals.CreateFallingKey.connect(CreateFallingKey)
	Signals.CreateFallingSpikes.connect(CreateFallingSpikes)
	# Initialize sprite position
	get_parent().get_node("AnimatedSprite2D").position.y = base_y_position


func _process(delta):
	
	# Apply gravity if jumping
	if is_jumping:
		# Apply velocity and gravity
		current_jump_velocity += gravity * delta
		get_parent().get_node("AnimatedSprite2D").position.y += current_jump_velocity * delta
		
		# Check if back to or below original base position
		if get_parent().get_node("AnimatedSprite2D").position.y >= base_y_position:
			get_parent().get_node("AnimatedSprite2D").position.y = base_y_position
			is_jumping = false
			current_jump_velocity = 0
	
	# Check for spike collisions
	if spike_idx < len(falling_spikes_queue):
		var spike = falling_spikes_queue[spike_idx]
		var distance_from_pass = abs(spike.pass_threshold - spike.global_position.x)
		
		# If the spike is near the press zone and player presses the key
		if distance_from_pass < perfect_press_threshold:
			# Check if player is NOT jumping (for up spikes)
			var sprite_offset_y = get_parent().get_node("AnimatedSprite2D").position.y
			
			var cur_animation_spiketest = get_parent().get_node("AnimatedSprite2D").animation
			if spike.has_damaged_player == false and (cur_animation_spiketest != "upward" and cur_animation_spiketest != "up_punch" and cur_animation_spiketest != "fall"):
				# Player didn't jump over the spike - apply penalty
				Signals.IncrementScore.emit(spike_penalty)
				print("HIT BY SPIKE D:")
				#var st_inst = score_text.instantiate()
				#get_tree().get_root().call_deferred("add_child", st_inst)
				#st_inst.SetTextInfo("OUCH!")
				Signals.ResetCombo.emit()
				spike.has_damaged_player = true
				#st_inst.global_position = global_position + Vector2(0, -15)
				
				# Optional: Play hurt animation
				#get_parent().get_node("AnimatedSprite2D").play("hurt")
				
				# Remove the spike
				spike.queue_free()
				spike_idx += 1
		
		# Spike passed safely
		elif spike.has_passed:
			spike_idx += 1
			Signals.IncrementScore.emit(10) # reward for avoiding spike
			print("PASSED SPIKE YIPPEE!!")
	
	if Input.is_action_just_pressed(key_name):
		
		print(key_name)
		var cur_animation = get_parent().get_node("AnimatedSprite2D").animation
		if key_name == 'button_up_smack':
			if cur_animation == "run" || cur_animation == "downward" || cur_animation == "low_punch" || cur_animation == "low_punch": 
				get_parent().get_node("AnimatedSprite2D").play("upward")
				# Start a jump with an initial velocity rather than instantly moving
				current_jump_velocity = jump_velocity
				is_jumping = true
				print(get_parent().get_node("AnimatedSprite2D").animation)
			else:
				get_parent().get_node("AnimatedSprite2D").play("up_punch")
				print(get_parent().get_node("AnimatedSprite2D").animation)
		elif key_name == 'button_down_smack':
			if cur_animation == "run" || cur_animation == "downward" || cur_animation == "low_punch": 
				get_parent().get_node("AnimatedSprite2D").position.y = base_y_position
				is_jumping = false
				current_jump_velocity = 0
				get_parent().get_node("AnimatedSprite2D").play("low_punch")
				print(get_parent().get_node("AnimatedSprite2D").animation)
			else:
				get_parent().get_node("AnimatedSprite2D").position.y = base_y_position
				is_jumping = false
				current_jump_velocity = 0
				get_parent().get_node("AnimatedSprite2D").play("downward")
				print(get_parent().get_node("AnimatedSprite2D").animation)
				
		Signals.KeyListenerPress.emit(key_name, frame) # if frame doesn't line up, might have to use export variable in this script
	
	
	if ktp_idx < len(falling_key_queue):
		if falling_key_queue[ktp_idx].has_passed:
			ktp_idx += 1
			
			# player didn't press anything
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo("MISS")
			substats_ct[4]  = substats_ct[4] + 1
			Signals.ResetCombo.emit()
			st_inst.global_position = global_position + Vector2(0, -15)
		
		if Input.is_action_just_pressed(key_name):
			
			var key_to_pop = falling_key_queue[ktp_idx]
			
			var distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.x)
			var press_score_text: String = ""
			
			
			$AnimationPlayer.stop()
			$AnimationPlayer.play("key_hit")
			
			
			if distance_from_pass < perfect_press_threshold:
				Signals.IncrementScore.emit(perfect_press_score)
				press_score_text = "PERFECT"
				substats_ct[0]  = substats_ct[0] + 1
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < great_press_threshold:
				Signals.IncrementScore.emit(great_press_score)
				press_score_text = "GREAT"
				substats_ct[1]  = substats_ct[1] + 1
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < good_press_threshold:
				Signals.IncrementScore.emit(good_press_score)
				press_score_text = "GOOD"
				substats_ct[2]  = substats_ct[2] + 1
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < ok_press_threshold:
				Signals.IncrementScore.emit(ok_press_score)
				press_score_text = "OK"
				substats_ct[3]  = substats_ct[3] + 1
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < 300:
				press_score_text = "MISS"
				substats_ct[4]  = substats_ct[4] + 1
				Signals.ResetCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.SetTextInfo(press_score_text)
			st_inst.global_position = global_position + Vector2(0, -15)

func CreateFallingKey(button_name: String):
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)
		fk_inst.Setup(position.y, frame + 4)
		
		falling_key_queue.push_back(fk_inst)

func CreateFallingSpikes(button_name):
	print("FALLING SPIKE")
	if button_name == key_name:
		var fs_inst = falling_spikes.instantiate()
		get_tree().get_root().call_deferred("add_child", fs_inst)
		fs_inst.Setup(position.y, frame + 4, key_name)
		
		falling_spikes_queue.push_back(fs_inst)

func _on_random_spawn_timer_timeout():
	#CreateFallingKey()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()

func _on_animated_sprite_2d_animation_finished():
	var cur_animation = get_parent().get_node("AnimatedSprite2D").animation
	var next_animation = ""
	
	if cur_animation == "upward" || cur_animation == "up_punch": 
		next_animation = "fall"
	else: 
		next_animation = "run"
	
	# Apply position correction before switching animations
	var current_offset = animation_offsets[cur_animation]
	var next_offset = animation_offsets[next_animation]
	# Calculate position adjustment needed
	var position_adjustment = next_offset - current_offset
	
	# Apply the adjustment
	get_parent().get_node("AnimatedSprite2D").position.y += position_adjustment.y
	# Change animation
	get_parent().get_node("AnimatedSprite2D").play(next_animation)
