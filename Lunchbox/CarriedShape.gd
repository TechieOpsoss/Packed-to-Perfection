extends Node2D

var checkDrop: Callable
signal dropSuccess()
signal dropFailure()

@export var shape: Array[Vector2i]
@export var triangle_width: float = 96
var triangle_height: float = triangle_width * sin(deg_to_rad(60))
var triangle_circumradius: float = triangle_width / sqrt(3)
var triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
@export var spacing_width: float = 93
var spacing_height: float = spacing_width * sin(deg_to_rad(60))
var spacing_circumradius: float = spacing_width / sqrt(3)
func make_meshes(gridSpaceCellPositions: Array[Vector2i]) -> Array[PackedVector2Array]:
	var ret: Array[PackedVector2Array] = []
	for gridSpaceCellPosition: Vector2i in gridSpaceCellPositions:
		if ((gridSpaceCellPosition.x % 2) == (gridSpaceCellPosition.y % 2)):
			ret.append(PackedVector2Array(
			[
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(-spacing_width/2,spacing_height-spacing_circumradius),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(0,-spacing_circumradius),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(spacing_width/2,spacing_height-spacing_circumradius)
			]))
		else:
			var verticalOffset: float = triangle_circumradius - triangle_height / 2
			ret.append(PackedVector2Array(
			[
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(-spacing_width/2,spacing_circumradius-spacing_height) - Vector2(0, verticalOffset*2),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(0,spacing_circumradius) - Vector2(0, verticalOffset*2),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(spacing_width/2,spacing_circumradius-spacing_height) - Vector2(0, verticalOffset*2)
			]))
	return ret

func combine_meshes(meshes: Array[PackedVector2Array]) -> Array:
	var ret1: PackedVector2Array = []
	var ret2: Array[PackedInt32Array] = []
	for triangleMesh: PackedVector2Array in meshes:
		ret2.append(PackedInt32Array([ret1.size(), ret1.size() + 1, ret1.size() + 2]))
		ret1.append_array(triangleMesh)
	return [ret1, ret2]

func change_shape(polygon2D: Polygon2D, gridSpaceCellPositions: Array[Vector2i]):
	# Construct new polygons, with (0,0) centered on centroid
	var combinedMeshes = combine_meshes(make_meshes(gridSpaceCellPositions))
	polygon2D.polygon = combinedMeshes[0]
	polygon2D.polygons = combinedMeshes[1]

# Delete when dropped.
func _ready() -> void:
	dropSuccess.connect(queue_free)
	dropFailure.connect(queue_free)
	change_shape(find_child("Render Polygon"), shape)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dropHard()
			get_viewport().set_input_as_handled()

#TODO: ghost preview

func dropSoft():
	print("soft drop")
	if checkDrop.call(shape, position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()

func dropHard():
	print("hard drop")
	if checkDrop.call(shape, position, (roundi(global_rotation_degrees / 60) + 6) % 6):
		dropSuccess.emit()
	else:
		dropFailure.emit()
