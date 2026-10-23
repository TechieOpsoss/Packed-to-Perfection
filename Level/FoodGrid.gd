# Attached to blank node that acts as cursor and carries shapes.
class_name FoodGrid extends Node2D

@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
@export var triangleWidth: float = 96
@export var emptyCellSpacing: float = 6
@export var filledCellSpacing: float = 6
@export var previewCellSpacing: float = 0

var emptyCells: Array[Vector2i]
var placedFoodStats: Array[FoodItemStats]

func updateGridVisuals() -> void:
	# Background
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(gridShape, triangleWidth, 0))
	$CellBackgroundVisual.polygon = verticesAndIndices[0]
	$CellBackgroundVisual.polygons = verticesAndIndices[1]
	# Empty cells
	verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(emptyCells, triangleWidth, emptyCellSpacing))
	$EmptyCellVisual.polygon = verticesAndIndices[0]
	$EmptyCellVisual.polygons = verticesAndIndices[1]

func _ready() -> void:
	emptyCells = gridShape.duplicate()
	
	updateGridVisuals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move cursor to cursor position.
	$Cursor.global_position = get_viewport().get_mouse_position()
	# Rotate cursor.
	if (Input.is_action_just_pressed("shape_rotate_cw")):
		$Cursor.rotation = fmod($Cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("shape_rotate_ccw")):
		$Cursor.rotation = fmod($Cursor.rotation + deg_to_rad(300), deg_to_rad(360))
	
func tryDrop(tryShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int, stats: FoodItemStats, returnShape: Callable) -> bool:
	var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - global_position, (shapeRotation % 2) == 1, triangleWidth)
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, shapeRotation), originPos)
	for transformedCell: Vector2i in transformedShape:
		if emptyCells.find(transformedCell) == -1:
			return false
	
	var droppedFood: FoodProducer = preload("res://Level/FoodDropped.tscn").instantiate()
	
	droppedFood.foodStats = stats
	droppedFood.producerShape = transformedShape
	droppedFood.producedShape = tryShape
	droppedFood.triangleWidth = triangleWidth
	droppedFood.cellSpacing = filledCellSpacing
	droppedFood.grid = self
	droppedFood.returnShape = returnShape
	droppedFood.depleted.connect(func():
		for transformedCell: Vector2i in transformedShape:
			emptyCells.append(transformedCell)
		updateGridVisuals()
	)
	
	add_child(droppedFood)
	
	# Add stats
	placedFoodStats.append(stats)
	
	for transformedCell: Vector2i in transformedShape:
		emptyCells.remove_at(emptyCells.find(transformedCell))
	
	updateGridVisuals()
	
	return true
