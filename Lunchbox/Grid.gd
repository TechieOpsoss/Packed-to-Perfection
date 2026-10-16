# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

@export var gridShape: Array[Vector2i] = [Vector2i(0,0)]
@export var triangle_width: float = 96
@export var spacing: float = 3
var cursor: Node2D

func _ready() -> void:
	cursor = find_child("Cursor")
	var polygon2D: Polygon2D = find_child("Render Polygon")
	var combinedMeshes = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(gridShape, triangle_width, spacing))
	polygon2D.polygon = combinedMeshes[0]
	polygon2D.polygons = combinedMeshes[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move cursor to cursor position.
	cursor.global_position = get_viewport().get_mouse_position()
	# Rotate cursor.
	if (Input.is_action_just_pressed("ui_right")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("ui_left")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(300), deg_to_rad(360))

#TODO: grid shape visual
#TODO: checkDrop. just. all of it

func checkDrop(_shape: Array[Vector2i], _position: Vector2, rotation: int) -> bool:
	return false

# Carried shape production.
const carriedShapeScene: Resource = preload("res://Lunchbox/CarriedShape.tscn")
func produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable):
	# Create and initialize instance.
	var carriedShapeInstance: Node2D = carriedShapeScene.instantiate()
	carriedShapeInstance.shape = producedShape
	carriedShapeInstance.position += cursorOffset
	
	carriedShapeInstance.checkDrop = checkDrop
	
	# When bucket button released, drop softly.
	letGoFromBucket.connect(carriedShapeInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedShapeInstance.dropFailure.connect(returnToBucket)
	
	# Randomize fetched rotation for flavor.
	cursor.rotation = randi_range(0,5) * deg_to_rad(60)
	
	cursor.add_child(carriedShapeInstance)
