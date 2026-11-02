class_name FoodCarried extends Node2D

@export var grid: FoodGrid
@export var item: FoodItem
@export var triangle_width: float = 24
@export var spacing: float = 4
@export var tryDrop: Callable
@export var returnShape: Callable

const DropTime: float = 0.25
const DropDistance: float = 128

var initialPosition: Vector2
var previewPolygon: Polygon2D
var dropTimePassed: bool

signal dropSuccess()
signal dropFailure()

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
	
	LocalAudioManager.play_sfx("res://Audio/soundeffects/Rotate.wav", 0.1, 1.2 * randf_range(0.8, 1.0))
	dropSuccess.connect(func(): LocalAudioManager.play_sfx("res://Audio/soundeffects/Rotate.wav", 0.2, 0.6 * randf_range(0.8, 1.0)))
	dropFailure.connect(func(): LocalAudioManager.play_sfx("res://Audio/soundeffects/Rotate.wav", 0.2, 0.2 * randf_range(0.8, 1.0)))
	
	# Setup visuals
	var tris: Array[PackedVector2Array] = TriGridUtils.make_meshes(item.shape, triangle_width, spacing)
	#var verticesAndIndices = TriGridUtils.combine_meshes(tris)
	#$ReferenceVisual.polygon = verticesAndIndices[0]
	#$ReferenceVisual.polygons = verticesAndIndices[1]
	#$ReferenceVisual.color = item.color
	var minVertexBounds = tris[0][0]
	var maxVertexBounds = tris[0][0]
	for tri in tris:
		for vertex in tri:
			minVertexBounds.x = min(minVertexBounds.x, vertex.x)
			minVertexBounds.y = min(minVertexBounds.y, vertex.y)
			maxVertexBounds.x = max(maxVertexBounds.x, vertex.x)
			maxVertexBounds.y = max(maxVertexBounds.y, vertex.y)
	var shapeSize = maxVertexBounds - minVertexBounds
	var textureSize = item.texture.get_size()
	var maxRatio = max(shapeSize.x, shapeSize.y) / max(textureSize.x, textureSize.y)
	$Visual.scale = Vector2(maxRatio, maxRatio)
	$Visual.texture = item.texture
	$Visual.position = (minVertexBounds + maxVertexBounds) / 2
	
	previewPolygon = grid.find_child("DropPreview")
	
	dropFailure.connect(func():
		previewPolygon.polygon = []
		previewPolygon.polygons = []
	)
	dropSuccess.connect(func():
		previewPolygon.polygon = []
		previewPolygon.polygons = []
	)
	
	initialPosition = global_position
	
	await get_tree().create_timer(DropTime).timeout
	dropTimePassed = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			drop()
			get_viewport().set_input_as_handled()
		else:
			if dropTimePassed or (global_position - initialPosition).length() > DropDistance:
				drop()
			get_viewport().set_input_as_handled()

func _process(_delta: float) -> void:
	if not is_queued_for_deletion():
		if grid.checkDrop(item.shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6):
			previewPolygon.color = Color(0, 0, 1, 0.5)
		else:
			previewPolygon.color = Color(1, 0, 0, 0.25)
		updatePreview(item.shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6)

func drop():
	if tryDrop.call(item.shape, global_position, (roundi(global_rotation_degrees / 60) + 6) % 6, item, returnShape):
		dropSuccess.emit()
	else:
		dropFailure.emit()
