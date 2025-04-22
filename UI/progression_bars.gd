extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$compassion.get("theme_override_styles/fill").bg_color = Color.HOT_PINK
	$connectivity.get("theme_override_styles/fill").bg_color = Color.HOT_PINK
	$ecoanxiety.get("theme_override_styles/fill").bg_color = Color.HOT_PINK
	
	$compassion.add_theme_color_override("font_color", Color.WHITE)
	$connectivity.add_theme_color_override("font_color", Color.WHITE)
	$ecoanxiety.add_theme_color_override("font_color", Color.WHITE)
	
	var bg_style = $compassion.get("theme_override_styles/bg")
	if bg_style and bg_style is StyleBoxFlat:
		bg_style.border_color = Color.BLACK
		bg_style.border_width_all = 5
		
	var bg_style2 = $connectivity.get("theme_override_styles/bg")
	if bg_style2 and bg_style2 is StyleBoxFlat:
		bg_style2.border_color = Color.BLACK
		bg_style2.border_width_all = 5
	
	var bg_style3 = $ecoanxiety.get("theme_override_styles/bg")
	if bg_style3 and bg_style3 is StyleBoxFlat:
		bg_style3.border_color = Color.BLACK
		bg_style3.border_width_all = 5
	
	
	# LABELS
	var bg_style4 = StyleBoxFlat.new()
	bg_style4.bg_color = Color.WHITE
	$Label.add_theme_stylebox_override("normal", bg_style4)
	
	var bg_style5 = StyleBoxFlat.new()
	bg_style5.bg_color = Color.WHITE
	$Label2.add_theme_stylebox_override("normal", bg_style5)
	
	var bg_style6 = StyleBoxFlat.new()
	bg_style6.bg_color = Color.WHITE
	$Label3.add_theme_stylebox_override("normal", bg_style6)
	




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
