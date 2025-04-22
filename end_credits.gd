extends Node2D

# References for UI elements
@onready var credits_container = $CreditsContainer
@onready var left_images = $LeftImages
@onready var right_images = $RightImages
@onready var thank_you_label = $ThankYouLabel
@onready var game_title_label = $GameTitleLabel
@onready var ygda_label = $YGDALabel
@onready var audio_player = $AudioPlayer
@onready var animation_player = $AnimationPlayer

# Scroll speed and duration
@export var scroll_speed: int = 45
@export var scroll_duration: int = 70  # Duration in seconds

# Variables to control the state
var scrolling = true
var final_phase = false
var credits_finished = false

func _ready():
	
	$Timer.timeout.connect(start_final_phase)
	
	# Initialize the credits position
	credits_container.position.y = get_viewport_rect().size.y
	
	# Hide labels initially
	thank_you_label.modulate.a = 0
	game_title_label.modulate.a = 0
	if ygda_label:
		ygda_label.modulate.a = 0
	
	# Make sure audio is set up correctly
	if audio_player.stream:
		# Set the audio to not fade out prematurely
		audio_player.autoplay = false  # We'll play it manually
		# Make sure it doesn't have a short fade-out time
		audio_player.stream.loop = false  # Don't loop
		print("Audio duration: ", audio_player.stream.get_length(), "s")
	else:
		print("WARNING: No audio stream assigned to AudioPlayer")
	
	# Start the audio
	audio_player.play()
	
	# Set up and start animation
	setup_animations()
	animation_player.play("scroll_credits")
	print("Animation started: ", animation_player.is_playing())

func position_images():
	# Position the image containers on the sides
	left_images.position.x = 50
	right_images.position.x = get_viewport_rect().size.x - 50
	
	# Space out the images within each container
	space_images(left_images)
	space_images(right_images)

func space_images(container):
	var spacing = get_viewport_rect().size.y / (container.get_child_count() + 1)
	for i in range(container.get_child_count()):
		var image = container.get_child(i)
		image.position.y = spacing * (i + 1)

func setup_animations():
	# Create an animation library
	var library = AnimationLibrary.new()
	
	# Create scroll animation
	var animation = Animation.new()
	animation.length = scroll_duration  # Set the animation length
	
	# Add track for credits scrolling - we need the FULL path to the node
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	# Use the CORRECT path to your credits container
	animation.track_set_path(track_index, "CreditsContainer:position:y")
	animation.track_insert_key(track_index, 0, credits_container.position.y)
	
	# Calculate how far we need to scroll
	var scroll_distance = -credits_container.size.y - get_viewport_rect().size.y
	animation.track_insert_key(track_index, scroll_duration, scroll_distance)
	
	# Make sure we're using the right curve type for smooth animation
	animation.value_track_set_update_mode(track_index, Animation.UPDATE_CONTINUOUS)
	
	# Add the animation to the library
	library.add_animation("scroll_credits", animation)
	
	
	# Create final animation (Thank You and title reveal)
	var final_animation = Animation.new()
	final_animation.length = 10  # 10 seconds for the final sequence
	
	# Add track for "Thank You" fade in
	track_index = final_animation.add_track(Animation.TYPE_VALUE)
	final_animation.track_set_path(track_index, "ThankYouLabel:modulate:a")
	final_animation.track_insert_key(track_index, 0, 0)
	final_animation.track_insert_key(track_index, 1, 1)
	
	# Add track for "Thank You" fade out
	track_index = final_animation.add_track(Animation.TYPE_VALUE)
	final_animation.track_set_path(track_index, "ThankYouLabel:modulate:a")
	final_animation.track_insert_key(track_index, 3, 1)
	final_animation.track_insert_key(track_index, 4, 0)
	
	# YGDA LABEL FADE IN
	track_index = final_animation.add_track(Animation.TYPE_VALUE)
	final_animation.track_set_path(track_index, "YGDALabel:modulate:a")
	final_animation.track_insert_key(track_index, 4, 0)
	final_animation.track_insert_key(track_index, 5, 1)
	
	# YGDA LABEL FADE OUT
	track_index = final_animation.add_track(Animation.TYPE_VALUE)
	final_animation.track_set_path(track_index, "YGDALabel:modulate:a")
	final_animation.track_insert_key(track_index, 7, 1)
	final_animation.track_insert_key(track_index, 8, 0)
	
	# Add track for game title fade in
	track_index = final_animation.add_track(Animation.TYPE_VALUE)
	final_animation.track_set_path(track_index, "GameTitleLabel:modulate:a")
	final_animation.track_insert_key(track_index, 8, 0)
	final_animation.track_insert_key(track_index, 9, 1)
	
	# Add the final animation to the library
	library.add_animation("final_phase", final_animation)
	
	
	
	# Add the library to the animation player
	animation_player.add_animation_library("", library)
	
	# Debug additional information
	print("Animation player ready: ", animation_player.has_animation("scroll_credits"))
	print("Credits container global position: ", credits_container.global_position)
	print("Credits container size: ", credits_container.size)

func _process(delta):
	# Monitor the credits container position instead of relying only on animation state
	if scrolling and not final_phase:
		# Check if the animation is done by position rather than animation state
		if credits_container.position.y <= -credits_container.size.y + get_viewport_rect().size.y:
			print("Credits reached end position by position check")
			scrolling = false
			$Timer.start()  # Start the 4-second timer
			print("Waiting 4 seconds before final phase...")
		
		# Also check animation state as a backup
		if animation_player.current_animation == "scroll_credits" and not animation_player.is_playing():
			print("Credits reached end position by animation check")
			scrolling = false
			$Timer.start()  # Start the 4-second timer
			print("Waiting 4 seconds before final phase...")
	
	# Debug output every few seconds
	if Engine.get_frames_drawn() % 60 == 0:  # Every ~1 second at 60fps
		print("Credits Y pos: ", credits_container.position.y)
		print("Target Y pos: ", -credits_container.size.y + get_viewport_rect().size.y)
		print("Animation playing: ", animation_player.is_playing())
		print("Current animation: ", animation_player.current_animation)
		print("Final phase: ", final_phase)

# New function to handle the transition
func start_final_phase():
	scrolling = false
	final_phase = true
	
	# Make sure the credits are fully scrolled
	credits_container.position.y = -credits_container.size.y
	
	# Manually control the label animations with longer durations
	var tween = create_tween()
	
	# First fade in Thank You
	tween.tween_property(thank_you_label, "modulate:a", 1.0, 1.5)  # Slower fade in (1.5s)
	# Wait 4 seconds instead of 2
	tween.tween_interval(4.0)
	# Fade out Thank You
	tween.tween_property(thank_you_label, "modulate:a", 0.0, 1.5)  # Slower fade out (1.5s)
	
	# Fade in YGDA
	tween.tween_property(ygda_label, "modulate:a", 1.0, 1.5)  # Slower fade in
	# Wait 4 seconds
	tween.tween_interval(4.0)
	# Fade out YGDA
	tween.tween_property(ygda_label, "modulate:a", 0.0, 1.5)  # Slower fade out
	
	# Fade in Game Title - leave this visible longer
	tween.tween_property(game_title_label, "modulate:a", 1.0, 1.5)  # Slower fade in
	# Wait 6 seconds for the game title to stay visible
	tween.tween_interval(6.0)
	
	# Signal when all animations complete
	tween.tween_callback(func(): credits_finished = true)
	
	print("Starting final phase animations with tween")
