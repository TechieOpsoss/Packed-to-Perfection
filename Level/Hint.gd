extends Label
var state: int = -1
var hintBox = load("res://Level/HintBox.tres")

# This could all be done with modulate.a to make the code simpler but it works as-is
func _show() -> void:
	show()
	add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0))
	hintBox.bg_color *= Color(1,1,1,0)
	hintBox.shadow_color *= Color(1,1,1,0)
	while get_theme_color("font_color").a < 1:
		add_theme_color_override("font_color", get_theme_color("font_color") + Color(0,0,0,0.01))
		hintBox.bg_color += Color(0,0,0,0.01)
		hintBox.shadow_color += Color(0,0,0,0.005)
		await get_tree().create_timer(0.01).timeout
	add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0) + Color(0,0,0,1))
	hintBox.bg_color *= Color(1,1,1,0)
	hintBox.shadow_color *= Color(1,1,1,0)
	hintBox.bg_color += Color(0,0,0,1)
	hintBox.shadow_color += Color(0,0,0,0.5)
	state = 0

func _hide() -> void:
	if Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_RIGHT != 0 and state == 0:
		state = -1
		while get_theme_color("font_color").a > 0:
			add_theme_color_override("font_color", get_theme_color("font_color") - Color(0,0,0,0.01))
			hintBox.bg_color -= Color(0,0,0,0.01)
			hintBox.shadow_color -= Color(0,0,0,0.005)
			await get_tree().create_timer(0.01).timeout
		add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0))
		hintBox.bg_color *= Color(1,1,1,0)
		hintBox.shadow_color *= Color(1,1,1,0)
		
		text = "Right click or\nscroll while holding\nfood to rotate it"
		await get_tree().create_timer(1).timeout
		
		while get_theme_color("font_color").a < 1:
			add_theme_color_override("font_color", get_theme_color("font_color") + Color(0,0,0,0.01))
			hintBox.bg_color += Color(0,0,0,0.01)
			hintBox.shadow_color += Color(0,0,0,0.005)
			await get_tree().create_timer(0.01).timeout
		add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0) + Color(0,0,0,1))
		hintBox.bg_color *= Color(1,1,1,0)
		hintBox.shadow_color *= Color(1,1,1,0)
		hintBox.bg_color += Color(0,0,0,1)
		hintBox.shadow_color += Color(0,0,0,0.5)
		await get_tree().create_timer(1).timeout
		state = 1
	elif Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_LEFT != 0 and state == 1:
		state = -1
		while get_theme_color("font_color").a > 0:
			add_theme_color_override("font_color", get_theme_color("font_color") - Color(0,0,0,0.01))
			hintBox.bg_color -= Color(0,0,0,0.01)
			hintBox.shadow_color -= Color(0,0,0,0.005)
			await get_tree().create_timer(0.01).timeout
		add_theme_color_override("font_color", get_theme_color("font_color") * Color(1,1,1,0))
		hintBox.bg_color *= Color(1,1,1,0)
		hintBox.shadow_color *= Color(1,1,1,0)
