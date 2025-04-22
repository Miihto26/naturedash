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
@export var scroll_speed: int = 50
@export var scroll_duration: int = 60  # Duration in seconds

# Variables to control the state
var scrolling = true
var final_phase = false
var credits_finished = false

func _ready():
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
	
	# ... rest of your animation setup ...
	
	# Add the library to the animation player
	animation_player.add_animation_library("", library)
	
	# Debug additional information
	print("Animation player ready: ", animation_player.has_animation("scroll_credits"))
	print("Credits container global position: ", credits_container.global_position)
	print("Credits container size: ", credits_container.size)

func _process(delta):
	# Monitor the animation progress
	if animation_player.current_animation == "scroll_credits" and not animation_player.is_playing() and not final_phase:
		# Start the final phase
		final_phase = true
		animation_player.play("final_phase")
		print("Starting final phase animation")
	
	# Once final animation is done, set credits_finished to true
	if final_phase and animation_player.current_animation == "final_phase" and not animation_player.is_playing():
		credits_finished = true
		print("Credits finished")

func _input(event):
	# Prevent any input actions after credits are done
	if credits_finished:
		get_viewport().set_input_as_handled()
