# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
var emptyCells: Array[Vector2i]
var filledCells: Array[Vector2i]
@export var triangleWidth: float = 96
@export var emptyCellSpacing: float = 6
@export var filledCellSpacing: float = 6
@export var previewCellSpacing: float = 0

func updateGridVisuals() -> void:
	# Background
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(gridShape, triangleWidth, 0))
	$CellBackgroundVisual.polygon = verticesAndIndices[0]
	$CellBackgroundVisual.polygons = verticesAndIndices[1]
	# Empty cells
	verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(emptyCells, triangleWidth, emptyCellSpacing))
	$EmptyCellVisual.polygon = verticesAndIndices[0]
	$EmptyCellVisual.polygons = verticesAndIndices[1]
	# Filled cells TODO: UV and texture
	verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(filledCells, triangleWidth, filledCellSpacing))
	$FilledCellVisual.polygon = verticesAndIndices[0]
	$FilledCellVisual.polygons = verticesAndIndices[1]

func _ready() -> void:
	emptyCells = gridShape.duplicate()
	filledCells = []
	
	updateGridVisuals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move cursor to cursor position.
	$Cursor.global_position = get_viewport().get_mouse_position()
	# Rotate cursor.
	if (Input.is_action_just_pressed("ui_right")):
		$Cursor.rotation = fmod($Cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("ui_left")):
		$Cursor.rotation = fmod($Cursor.rotation + deg_to_rad(300), deg_to_rad(360))
	
func tryDrop(tryShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int) -> bool:
	var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - global_position, (shapeRotation % 2) == 1, triangleWidth)
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, shapeRotation), originPos)
	for transformedCell: Vector2i in transformedShape:
		if emptyCells.find(transformedCell) == -1:
			return false
	
	# TODO: store UV corresponding to food item texture
	
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
	carriedFoodInstance.updatePreview = func(previewShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int): 
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
	$Cursor.rotation = 0
	
	$Cursor.add_child(carriedFoodInstance)
