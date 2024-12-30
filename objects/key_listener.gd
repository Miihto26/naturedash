extends Sprite2D

@onready var falling_key = preload("res://objects/falling_key.tscn")
@onready var score_text = preload("res://objects/score_press_text.tscn")
@export var key_name: String = ""

var falling_key_queue = []

var perfect_press_threshold: float = 55
var great_press_threshold: float = 70
var good_press_threshold: float = 100
var ok_press_threshold: float = 120

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20

var ktp_idx = 0

func _ready():
	$GlowOverlay.frame = frame + 4
	get_parent().get_node("AnimatedSprite2D").play("run")
	Signals.CreateFallingKey.connect(CreateFallingKey)


func _process(delta):
	
	if Input.is_action_just_pressed(key_name):
		print(key_name)
		var cur_animation = get_parent().get_node("AnimatedSprite2D").animation
		if key_name == 'button_up_smack':
			if cur_animation == "run" || cur_animation == "downward" || cur_animation == "low_punch": 
				get_parent().get_node("AnimatedSprite2D").play("upward")
				print(get_parent().get_node("AnimatedSprite2D").animation)
			else:
				get_parent().get_node("AnimatedSprite2D").play("up_punch")
				print(get_parent().get_node("AnimatedSprite2D").animation)
		elif key_name == 'button_down_smack':
			if cur_animation == "run" || cur_animation == "downward" || cur_animation == "low_punch": 
				get_parent().get_node("AnimatedSprite2D").play("low_punch")
				print(get_parent().get_node("AnimatedSprite2D").animation)
			else:
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
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < great_press_threshold:
				Signals.IncrementScore.emit(great_press_score)
				press_score_text = "GREAT"
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < good_press_threshold:
				Signals.IncrementScore.emit(good_press_score)
				press_score_text = "GOOD"
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < ok_press_threshold:
				Signals.IncrementScore.emit(ok_press_score)
				press_score_text = "OK"
				Signals.IncrementCombo.emit()
				key_to_pop.queue_free()
				ktp_idx += 1
			elif distance_from_pass < 300:
				press_score_text = "MISS"
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

func _on_random_spawn_timer_timeout():
	#CreateFallingKey()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()

func _on_animated_sprite_2d_animation_finished():
	get_parent().get_node("AnimatedSprite2D").play("run")
