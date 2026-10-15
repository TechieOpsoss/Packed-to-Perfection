extends Node2D

var attemptDrop: Callable = func(_shape: Array[Vector2i]): return false
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

func dropSoft():
	if attemptDrop.call(shape):
		dropSuccess.emit()

func dropHard():
	if attemptDrop.call(shape):
		dropSuccess.emit()
	else:
		dropFailure.emit()
