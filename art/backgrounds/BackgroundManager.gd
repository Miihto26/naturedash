extends Node2D

# Dictionary mapping level names to their background resources
var background_resources = {
	"1-ENTER-EZRA": "res://art/backgrounds/1-ENTER-EZRA/parallax/",
	"2-THIS-IS-MY-WORLD": "res://art/backgrounds/2-THIS-IS-MY-WORLD/parallax/",
	"3-OUTTA-MY-WAY": "res://art/backgrounds/3-OUTTA-MY-WAY/parallax/",
	"4-GRAND-SLAM": "res://art/backgrounds/4-GRAND-SLAM/parallax/",
	"5-LUNABLADE": "res://art/backgrounds/5-LUNABLADE/parallax/",
	"6-WHITE-WINGS-OF-WONDER": "res://art/backgrounds/6-WHITE-WINGS-OF-WONDER/parallax/",
}

# List to track loaded background layers
var background_layers = []

# Background container
var background_container = null

# Background scaling and positioning
@export var scale_factor: float = 1.0  # Adjust this to scale all backgrounds
@export var centered: bool = true      # Center backgrounds on screen
@export var offset: Vector2 = Vector2(100, 50) #Vector2.ZERO  # Additional offset if needed

func _ready():
	# Create a container for all backgrounds
	background_container = Node2D.new()
	background_container.name = "BackgroundContainer"
	add_child(background_container)
	
	# Print available levels for debugging
	print("Available background levels: " + str(background_resources.keys()))

# Set the background based on level name
func set_level(level_name: String):
	print("BackgroundManager: Setting level to '" + level_name + "'")
	
	# First clear any existing background
	clear_background()
	
	# Check if we have a background for this level
	if not background_resources.has(level_name):
		print("No background found for level: '" + level_name + "'")
		
		# Try different variations of the level name
		var found = false
		for key in background_resources.keys():
			if key.to_lower() == level_name.to_lower():
				level_name = key
				found = true
				print("Found case-insensitive match: " + key)
				break
		
		if !found:
			# Check if it's a numeric level ID
			if level_name.is_valid_int():
				var numeric_level = "level" + level_name
				if background_resources.has(numeric_level):
					level_name = numeric_level
					found = true
					print("Found numeric match: " + numeric_level)
			
			if !found:
				print("Using default level1 background")
				level_name = "level1"  # Use default
	
	# Get the background directory for this level
	var bg_dir = background_resources[level_name]
	print("Looking for backgrounds in: " + bg_dir)
	
	# Load all background layers from the directory
	load_background_layers(bg_dir)
	
	# Apply scale after loading (this ensures scale is applied to all sprites)
	apply_scale_to_all_layers()

# Clear existing background layers
func clear_background():
	for layer in background_layers:
		if is_instance_valid(layer):
			layer.queue_free()
	background_layers.clear()

# Load all background layers from a directory
func load_background_layers(directory: String):
	print("Loading background layers from: " + directory)
	
	var dir = DirAccess.open(directory)
	if dir:
		# Use an array to sort files, so we can control the order
		var files = []
		
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			# Only process image files
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
		
		# Sort files to ensure consistent layer order (back to front)
		files.sort()
		
		# Keep track of layer Z-index for proper ordering
		var z_index = -100
		var layer_count = 0
		
		# Process sorted files
		for file_namei in files:
			print("Loading image: " + directory + file_namei)
			
			# Load the texture
			var texture = load(directory + file_namei)
			if not texture:
				print("Failed to load texture: " + directory + file_namei)
				continue
			
			print("Texture size: " + str(texture.get_size()))
				
			# Create sprite for the layer
			var sprite = Sprite2D.new()
			sprite.texture = texture
			sprite.z_index = z_index
			
			# Don't set scale here - we'll do it after all sprites are loaded
			# to ensure uniform scaling
			
			# Set initial position (will be adjusted by scale later)
			if centered:
				sprite.centered = true
				sprite.position = Vector2.ZERO  # Will be adjusted later
			else:
				sprite.centered = false
				sprite.position = Vector2.ZERO
				
			# Add the sprite to our container
			background_container.add_child(sprite)
			background_layers.append(sprite)
			
			print("Added background layer: " + file_namei + " at z_index " + str(z_index))
			layer_count += 1
			z_index += 1
		
		print("Total layers loaded: " + str(layer_count))
	else:
		print("Could not access directory: " + directory)

# Apply current scale to all layers
func apply_scale_to_all_layers():
	print("Applying scale factor: " + str(scale_factor))
	
	# Apply scale to container instead of individual sprites
	# This ensures consistent scaling
	background_container.scale = Vector2(scale_factor, scale_factor)
	
	# Update positions based on viewport
	update_positions()

# Update all sprite positions
func update_positions():
	var viewport_size = get_viewport_rect().size
	var center = viewport_size / 2
	
	# Position container at center of screen
	if centered:
		background_container.position = center + offset
	else:
		background_container.position = offset
	
	print("Container positioned at: " + str(background_container.position))
	print("Current viewport size: " + str(viewport_size))

# Adjust background position and scale at runtime if needed
func update_bg_scale(new_scale: float):
	print("Updating scale to: " + str(new_scale))
	scale_factor = new_scale
	apply_scale_to_all_layers()

func update_bg_position(new_position: Vector2):
	offset = new_position
	update_positions()

# Respond to window resize events
func _notification(what):
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		update_positions()

# Print debug info about current background setup
func print_debug_info():
	print("--- Background Manager Debug Info ---")
	print("Scale factor: " + str(scale_factor))
	print("Background container scale: " + str(background_container.scale))
	print("Background container position: " + str(background_container.position))
	print("Number of layers: " + str(background_layers.size()))
	
	for i in range(background_layers.size()):
		var sprite = background_layers[i]
		print("Layer " + str(i) + ":")
		print("  - Position: " + str(sprite.position))
		print("  - Scale: " + str(sprite.scale))
		print("  - Centered: " + str(sprite.centered))
		if sprite.texture:
			print("  - Texture size: " + str(sprite.texture.get_size()))
	
	print("Viewport size: " + str(get_viewport_rect().size))
	print("----------------------------------")
