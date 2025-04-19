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

# Set the background based on level name
func set_level(level_name: String):
	print("BackgroundManager: Setting level to " + level_name)
	
	# First clear any existing background
	clear_background()
	
	# Check if we have a background for this level
	if not background_resources.has(level_name):
		print("No background found for level: " + level_name)
		return
	
	# Get the background directory for this level
	var bg_dir = background_resources[level_name]
	
	# Load all background layers from the directory
	load_background_layers(bg_dir)

# Clear existing background layers
func clear_background():
	for layer in background_layers:
		layer.queue_free()
	background_layers.clear()

# Load all background layers from a directory
func load_background_layers(directory: String):
	# This requires the background assets to be named in order
	# e.g. bg_layer1.png, bg_layer2.png, etc.
	
	var dir = DirAccess.open(directory)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		# Keep track of layer Z-index for proper ordering
		var z_index = -100
		
		while file_name != "":
			# Only process image files
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
				# Create a parallax background for this layer
				var parallax_bg = ParallaxBackground.new()
				add_child(parallax_bg)
				background_layers.append(parallax_bg)
				
				# Create parallax layer
				var parallax_layer = ParallaxLayer.new()
				parallax_bg.add_child(parallax_layer)
				
				# Set motion scale based on layer (further back moves slower)
				# You might want to adjust these values
				var depth_factor = 1.0 - float(z_index + 100) / 10.0
				parallax_layer.motion_scale = Vector2(depth_factor, depth_factor)
				
				# Create sprite for the layer
				var sprite = Sprite2D.new()
				sprite.texture = load(directory + file_name)
				sprite.z_index = z_index
				parallax_layer.add_child(sprite)
				
				# Increment z_index for next layer
				z_index += 1
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	else:
		print("Could not access directory: " + directory)
