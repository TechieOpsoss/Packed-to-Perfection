extends Control

func _on_exit_pressed() -> void:
	get_parent().add_child(load("res://Menu/Menu.tscn").instantiate())
	queue_free()
