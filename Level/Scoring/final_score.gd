extends Control

func _ready():
	modulate.a = 0
	while not is_queued_for_deletion() and modulate.a < 0.99:
		modulate.a += 0.01
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion():
		modulate.a = 1

func _on_exit_pressed() -> void:
	get_parent().add_child(load("res://Menu/Menu.tscn").instantiate())
	queue_free()
