# Attached to blank node that acts as cursor and carries shapes.
class_name FoodGrid extends Node2D

@export var requirements: FoodItemStats
@export var receiptLayer: ReceiptLayer
@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
@export var triangleWidth: float = 36
@export var emptyCellSpacing: float = 6
@export var filledCellSpacing: float = 6
@export var previewCellSpacing: float = 0

var emptyCells: Array[Vector2i]
var placedFoodStats: Array[FoodItemStats]

func freezeDroppedFood():
	for droppedFoodItem: Area2D in $DroppedFoodItems.get_children():
		for connection in droppedFoodItem.input_event.get_connections():
			droppedFoodItem.input_event.disconnect(connection.callable)

func clearDroppedFood():
	for droppedFoodItem: Area2D in $DroppedFoodItems.get_children():
		droppedFoodItem.queue_free()
	for index in range(placedFoodStats.size(),0,-1):
		placedFoodStats.remove_at(index)

func totalStats() -> FoodItemStats:
	var sum: FoodItemStats = FoodItemStats.new()
	for placedFoodStat: FoodItemStats in placedFoodStats:
		sum.add(placedFoodStat)
	return sum

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
	if ($Cursor.get_child_count() > 0 and Input.is_action_just_pressed("shape_rotate_cw")):
		LocalAudioManager.play_sfx("res://Audio/soundeffects/Rotate.wav", 0.1, 2 * randf_range(0.8, 1.0))
		$Cursor.rotation = fmod($Cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if ($Cursor.get_child_count() > 0 and Input.is_action_just_pressed("shape_rotate_ccw")):
		LocalAudioManager.play_sfx("res://Audio/soundeffects/Rotate.wav", 0.1, 1.5 * randf_range(0.8, 1.0))
		$Cursor.rotation = fmod($Cursor.rotation + deg_to_rad(300), deg_to_rad(360))

func checkDrop(tryShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int) -> bool:
	var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - global_position, (shapeRotation % 2) == 1, triangleWidth)
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, shapeRotation), originPos)
	for transformedCell: Vector2i in transformedShape:
		if emptyCells.find(transformedCell) == -1:
			return false
	return true

func tryDrop(tryShape: Array[Vector2i], heldPosition: Vector2, shapeRotation: int, item: FoodItem, returnShape: Callable) -> bool:
	var originPos: Vector2i = TriGridUtils.screen_to_grid(heldPosition - global_position, (shapeRotation % 2) == 1, triangleWidth)
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, shapeRotation), originPos)
	for transformedCell: Vector2i in transformedShape:
		if emptyCells.find(transformedCell) == -1:
			return false
	
	var droppedFood: FoodProducer = preload("res://Level/Food/FoodDropped.tscn").instantiate()
	
	droppedFood.item = item
	droppedFood.producerShape = transformedShape
	droppedFood.triangleWidth = triangleWidth
	droppedFood.cellSpacing = filledCellSpacing
	droppedFood.grid = self
	droppedFood.returnShape = returnShape
	droppedFood.depleted.connect(func():
		for transformedCell: Vector2i in transformedShape:
			emptyCells.append(transformedCell)
		placedFoodStats.remove_at(placedFoodStats.find(item.stats))
		receiptLayer.update(totalStats(), requirements)
		updateGridVisuals()
	)
	
	$DroppedFoodItems.add_child(droppedFood)
	
	# Add stats
	placedFoodStats.append(item.stats)
	receiptLayer.update(totalStats(), requirements)
	
	for transformedCell: Vector2i in transformedShape:
		emptyCells.remove_at(emptyCells.find(transformedCell))
	
	updateGridVisuals()
	
	return true
