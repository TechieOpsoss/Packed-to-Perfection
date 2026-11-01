extends Label
var state: int = 0

func _hide() -> void:
	if state == 0:
		state = -1
		while get_theme_color("font_color").a > 0:
			add_theme_color_override("font_color", get_theme_color("font_color") - Color(0,0,0,0.01))
			await get_tree().create_timer(0.01).timeout
		add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0))
		text = "Right click or scroll while\nholding food to rotate"
		while get_theme_color("font_color").a < 1:
			add_theme_color_override("font_color", get_theme_color("font_color") + Color(0,0,0,0.01))
			await get_tree().create_timer(0.01).timeout
		add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0) + Color(0,0,0,1))
		await get_tree().create_timer(4).timeout
		state = 1
	elif state == 1:
		state = -1
		while get_theme_color("font_color").a > 0:
			add_theme_color_override("font_color", get_theme_color("font_color") - Color(0,0,0,0.01))
			await get_tree().create_timer(0.01).timeout
		add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0))
