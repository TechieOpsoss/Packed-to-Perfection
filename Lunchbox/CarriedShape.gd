extends Node2D

var tryDrop: Callable
signal dropSuccess()
signal dropFailure()

@export var shape: Array[Vector2i]
@export var triangle_width: float = 56
@export var spacing: float = 3

# Delete when dropped.
func _ready() -> void:
	dropSuccess.connect(queue_free)
	dropFailure.connect(queue_free)
	var polygon2D: Polygon2D = find_child("Render Polygon")
	var combinedMeshes = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(shape, triangle_width, spacing))
	polygon2D.polygon = combinedMeshes[0]
	polygon2D.polygons = combinedMeshes[1]

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dropHard()
			get_viewport().set_input_as_handled()

#TODO: ghost preview

func dropSoft():
	print("soft drop")
	if tryDrop.call(shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()

func dropHard():
	print("hard drop")
	if tryDrop.call(shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()
	else:
		dropFailure.emit()
