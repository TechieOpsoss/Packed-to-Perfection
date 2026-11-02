extends Node2D

func _ready() -> void:
	LocalAudioManager.play_music("res://Audio/Music/Menu.ogg")

func _on_play_button_pressed() -> void:
	hide()
	var levelController = preload("res://LevelControl/LevelController.tscn").instantiate()
	levelController.position.y = 345
	get_parent().add_child(levelController)
	levelController.up()
	await get_parent().up()
	await get_parent().flicker_on()
	levelController.pop_in()
	queue_free()
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
