# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
var freeCells: Array[Vector2i]
@export var triangle_width: float = 96
@export var spacing: float = 3
var cursor: Node2D

func _ready() -> void:
	cursor = find_child("Cursor")
	var polygon2D: Polygon2D = find_child("Render Polygon")
	var combinedMeshes = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(gridShape, triangle_width, spacing))
	polygon2D.polygon = combinedMeshes[0]
	polygon2D.polygons = combinedMeshes[1]
	freeCells = gridShape

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move cursor to cursor position.
	cursor.global_position = get_viewport().get_mouse_position()
	# Rotate cursor.
	if (Input.is_action_just_pressed("ui_right")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("ui_left")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(300), deg_to_rad(360))

func tryDrop(tryShape: Array[Vector2i], checkPosition: Vector2, rotation: int) -> bool:
	var originPos: Vector2i = TriGridUtils.screen_to_grid(checkPosition - global_position, (rotation % 2) == 1, triangle_width)
	var occupiedCells: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, rotation), originPos)
	for occupiedCell: Vector2i in occupiedCells:
		if freeCells.find(occupiedCell) == -1:
			return false
	#TODO: add DroppedShape at corresponding location
	for occupiedCell: Vector2i in occupiedCells:
		freeCells.remove_at(freeCells.find(occupiedCell))
	return true

# Carried shape production.
const carriedShapeScene: Resource = preload("res://Lunchbox/CarriedShape.tscn")
func produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable):
	# Create and initialize instance.
	var carriedShapeInstance: Node2D = carriedShapeScene.instantiate()
	carriedShapeInstance.shape = producedShape
	carriedShapeInstance.position += cursorOffset
	
	carriedShapeInstance.tryDrop = tryDrop
	
	# When bucket button released, drop softly.
	letGoFromBucket.connect(carriedShapeInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedShapeInstance.dropFailure.connect(returnToBucket)
	
	# Randomize fetched rotation for flavor.
	cursor.rotation = randi_range(0,5) * deg_to_rad(60)
	
	cursor.add_child(carriedShapeInstance)
