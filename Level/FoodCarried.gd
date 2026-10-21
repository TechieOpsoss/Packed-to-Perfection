extends Node2D

var updatePreview: Callable
var tryDrop: Callable

# TODO: Sounds on signals
signal dropSuccess()
signal dropFailure()
signal softFailure()

@export var shape: Array[Vector2i]
@export var triangle_width: float = 48
@export var spacing: float = 4

# Delete when dropped.
func _ready() -> void:
	dropSuccess.connect(queue_free)
	dropFailure.connect(queue_free)
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(shape, triangle_width, spacing))
	$Visual.polygon = verticesAndIndices[0]
	$Visual.polygons = verticesAndIndices[1]

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dropHard()
			get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if not is_queued_for_deletion():
		updatePreview.call(shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6)

#TODO: ghost preview

func dropSoft():
	if tryDrop.call(shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()
	else:
		softFailure.emit()

func dropHard():
	if tryDrop.call(shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()
	else:
		dropFailure.emit()
