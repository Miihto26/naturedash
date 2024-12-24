extends Control


func SetTextInfo(text: String):
	$ScoreLevelText.text = "[center]" + text
	
	match text:
		"PERFECT":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("86cecb"))
			$ScoreLevelText.set("theme_override_colors/font_outline_color", Color("137a7f"))
		"GREAT":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("86cecb"))
			$ScoreLevelText.set("theme_override_colors/font_outline_color", Color("137a7f"))
		"GOOD":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("86cecb"))
			$ScoreLevelText.set("theme_override_colors/font_outline_color", Color("137a7f"))
		"OK":
			$ScoreLevelText.set("theme_override_colors/default_color", Color("86cecb"))
			$ScoreLevelText.set("theme_override_colors/font_outline_color", Color("137a7f"))
		_:
			$ScoreLevelText.set("theme_override_colors/default_color", Color("86cecb"))
			$ScoreLevelText.set("theme_override_colors/font_outline_color", Color("137a7f"))
