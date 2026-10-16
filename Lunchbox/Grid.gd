# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
var freeCells: Array[Vector2i]
@export var triangle_width: float = 64
@export var spacing: float = 3
var cursor: Node2D

func _ready() -> void:
	cursor = find_child("Cursor")
	
	freeCells = gridShape
	
	var freePolygon2D: Polygon2D = find_child("Free Polygons")
	var combinedMeshes = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(freeCells, triangle_width, spacing))
	freePolygon2D.polygon = combinedMeshes[0]
	freePolygon2D.polygons = combinedMeshes[1]

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
	var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(tryShape, rotation), originPos)
	for transformedCell: Vector2i in transformedShape:
		if freeCells.find(transformedCell) == -1:
			return false
	
	#TODO: add DroppedShape at corresponding location
	
	for transformedCell: Vector2i in transformedShape:
		freeCells.remove_at(freeCells.find(transformedCell))
	
	var freePolygon2D: Polygon2D = find_child("Free Polygons")
	var combinedFreeMeshes = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(freeCells, triangle_width, spacing))
	freePolygon2D.polygon = combinedFreeMeshes[0]
	freePolygon2D.polygons = combinedFreeMeshes[1]
	
	return true

# Carried shape production.
const carriedShapeScene: Resource = preload("res://Lunchbox/CarriedShape.tscn")
func produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable):
	# Create and initialize instance.
	var carriedShapeInstance: Node2D = carriedShapeScene.instantiate()
	carriedShapeInstance.shape = producedShape
	carriedShapeInstance.position += cursorOffset
	
	carriedShapeInstance.tryDrop = tryDrop
	carriedShapeInstance.setPreview = func(previewShape: Array[Vector2i], checkPosition: Vector2, rotation: int): 
		var previewPolygon2D: Polygon2D = find_child("Preview Polygon")
		var originPos: Vector2i = TriGridUtils.screen_to_grid(checkPosition - global_position, (rotation % 2) == 1, triangle_width)
		var transformedShape: Array[Vector2i] = TriGridUtils.offset_grid(TriGridUtils.rotate_grid(previewShape, rotation), originPos)
		var combinedMeshes = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(transformedShape, triangle_width, spacing))
		previewPolygon2D.polygon = combinedMeshes[0]
		previewPolygon2D.polygons = combinedMeshes[1]
	carriedShapeInstance.dropFailure.connect(func(): 
		var previewPolygon2D: Polygon2D = find_child("Preview Polygon")
		previewPolygon2D.polygon = []
		previewPolygon2D.polygons = []
	)
	carriedShapeInstance.dropSuccess.connect(func(): 
		var previewPolygon2D: Polygon2D = find_child("Preview Polygon")
		previewPolygon2D.polygon = []
		previewPolygon2D.polygons = []
	)
	
	# When bucket button released, drop softly.
	letGoFromBucket.connect(carriedShapeInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedShapeInstance.dropFailure.connect(returnToBucket)
	
	# Randomize fetched rotation for flavor.
	cursor.rotation = randi_range(0,5) * deg_to_rad(60)
	
	cursor.add_child(carriedShapeInstance)
