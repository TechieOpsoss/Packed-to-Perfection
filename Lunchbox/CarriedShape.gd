extends Node2D

func alwaysFail(shape: Array[Vector2i]):
	return false
var attemptDrop: Callable = alwaysFail
#signal attemptDrop(shape: Array[Vector2i], success: Callable, failure: Callable)
signal dropSuccess()
signal dropFailure()

var shape: Array[Vector2i]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dropSuccess.connect(queue_free)
	dropFailure.connect(queue_free)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dropHard()
			get_viewport().set_input_as_handled()

func dropSoft():
	print("soft drop")
	if attemptDrop.call(shape):
		dropSuccess.emit()

func dropHard():
	print("hard drop")
	if attemptDrop.call(shape):
		dropSuccess.emit()
	else:
		dropFailure.emit()
