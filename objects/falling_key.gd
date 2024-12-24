# perfect timing is at 1.875 s

extends Sprite2D

@export var tile_speed: float = 3.5
var init_x_pos: float = 1206
var has_passed: bool = false
var pass_threshold = 220

func _init():
	set_process(false)

func _process(delta):
	global_position += Vector2(-1*tile_speed, 0)
	
	if global_position.x < pass_threshold and not $Timer.is_stopped():
		# print($Timer.wait_time - $Timer.time_left)
		$Timer.stop()
		has_passed = true

func Setup(target_y: float, target_frame: int):
	global_position = Vector2(init_x_pos, target_y)
	frame = target_frame
	
	set_process(true)


func _on_destroy_timer_timeout():
	queue_free()
