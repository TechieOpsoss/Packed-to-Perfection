extends Node2D


func _on_submit_button_pressed() -> void:
	#TODO Add in per alien score card and Alien switch functionality here
	pass # Replace with function body.

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
