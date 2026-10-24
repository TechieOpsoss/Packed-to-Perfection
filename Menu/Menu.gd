extends Node2D

func _ready() -> void:
	LocalAudioManager.play_music("res://Audio/Music/Menu.ogg")

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://LevelControl/LevelController.tscn")
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
