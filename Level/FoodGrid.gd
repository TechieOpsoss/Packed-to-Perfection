# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
var emptyCells: Array[Vector2i]
var filledCells: Array[Vector2i]
@export var triangleWidth: float = 96
@export var gridCellSpacing: float = 8
@export var previewCellSpacing: float = 8
var cursor: Node2D

func updateGridVisuals() -> void:
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(emptyCells, triangleWidth, gridCellSpacing))
	$EmptyCellVisual.polygon = verticesAndIndices[0]
	$EmptyCellVisual.polygons = verticesAndIndices[1]
	verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(filledCells, triangleWidth, 0))
	$FilledCellVisual.polygon = verticesAndIndices[0]
	$FilledCellVisual.polygons = verticesAndIndices[1]

func _ready() -> void:
	cursor = find_child("Cursor")
	
	emptyCells = gridShape
	filledCells = []
	
	updateGridVisuals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move cursor to cursor position.
	cursor.global_position = get_viewport().get_mouse_position()
	# Rotate cursor.
	if (Input.is_action_just_pressed("ui_right")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("ui_left")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(300), deg_to_rad(360))
	
func tryDrop(tryShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int) -> bool:
	var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - global_position, (shapeRotation % 2) == 1, triangleWidth)
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, shapeRotation), originPos)
	for transformedCell: Vector2i in transformedShape:
		if emptyCells.find(transformedCell) == -1:
			return false
	
	#TODO: add DroppedShape at corresponding location
	
	for transformedCell: Vector2i in transformedShape:
		emptyCells.remove_at(emptyCells.find(transformedCell))
		filledCells.append(transformedCell)
	
	updateGridVisuals()
	
	return true

# Carried shape production.
const carriedFoodScene: Resource = preload("res://Level/FoodCarried.tscn")
func produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable):
	# Create and initialize instance.
	var carriedFoodInstance: Node2D = carriedFoodScene.instantiate()
	carriedFoodInstance.shape = producedShape
	carriedFoodInstance.position += cursorOffset
	
	carriedFoodInstance.tryDrop = tryDrop
	carriedFoodInstance.setPreview = func(previewShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int): 
		var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - global_position, (shapeRotation % 2) == 1, triangleWidth)
		var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(previewShape, shapeRotation), originPos)
		var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(transformedShape, triangleWidth, previewCellSpacing))
		$DropPreview.polygon = verticesAndIndices[0]
		$DropPreview.polygons = verticesAndIndices[1]
	carriedFoodInstance.dropFailure.connect(func():
		$DropPreview.polygon = []
		$DropPreview.polygons = []
	)
	carriedFoodInstance.dropSuccess.connect(func():
		$DropPreview.polygon = []
		$DropPreview.polygons = []
	)
	
	# When bucket button released, drop softly.
	letGoFromBucket.connect(carriedFoodInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedFoodInstance.dropFailure.connect(returnToBucket)
	
	# Reset fetched rotation for consistency.
	cursor.rotation = 0
	
	cursor.add_child(carriedFoodInstance)
