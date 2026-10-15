extends Node2D

var checkDrop: Callable
signal dropSuccess()
signal dropFailure()

var shape: Array[Vector2i]
# Delete when dropped.
func _ready() -> void:
	dropSuccess.connect(queue_free)
	dropFailure.connect(queue_free)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dropHard()
			get_viewport().set_input_as_handled()

#TODO: ghost preview
#TODO: shape visual

func dropSoft():
	if checkDrop.call(shape, position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()

func dropHard():
	if checkDrop.call(shape, position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()
	else:
		dropFailure.emit()
