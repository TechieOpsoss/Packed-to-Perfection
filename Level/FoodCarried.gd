class_name FoodCarried extends Node2D

@export var grid: FoodGrid
var previewPolygon: Polygon2D
var tryDrop: Callable

# TODO: Sounds on signals
signal dropSuccess()
signal dropFailure()
signal softFailure()

@export var shape: Array[Vector2i]
@export var triangle_width: float = 48
@export var spacing: float = 4

func updatePreview(previewShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int): 
	var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - grid.global_position, (shapeRotation % 2) == 1, grid.triangleWidth)
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(previewShape, shapeRotation), originPos)
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(transformedShape, grid.triangleWidth, grid.previewCellSpacing))
	previewPolygon.polygon = verticesAndIndices[0]
	previewPolygon.polygons = verticesAndIndices[1]

func _ready() -> void:
	# Delete when dropped.
	dropSuccess.connect(queue_free)
	dropFailure.connect(queue_free)
	# Setup visuals
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(shape, triangle_width, spacing))
	$Visual.polygon = verticesAndIndices[0]
	$Visual.polygons = verticesAndIndices[1]
	
	previewPolygon = grid.find_child("DropPreview")
	
	dropFailure.connect(func():
		previewPolygon.polygon = []
		previewPolygon.polygons = []
	)
	dropSuccess.connect(func():
		previewPolygon.polygon = []
		previewPolygon.polygons = []
	)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			dropHard()
			get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if not is_queued_for_deletion():
		updatePreview(shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6)

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
