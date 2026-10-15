# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

@export var gridShape: Array[Vector2i]
var cursor: Node2D

func _ready() -> void:
	cursor = find_child("Cursor")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move cursor to cursor position.
	cursor.position = get_viewport().get_mouse_position()
	# Rotate cursor.
	if (Input.is_action_just_pressed("ui_right")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("ui_left")):
		cursor.rotation = fmod(cursor.rotation + deg_to_rad(300), deg_to_rad(360))

# Carried shape production.
const carriedShapeScene: Resource = preload("res://Lunchbox/CarriedShape.tscn")
func produceShape(producedShape: Array[Vector2i], offset: Vector2, letGo: Signal, returnShape: Callable):
	# Create and initialize instance.
	var carriedShapeInstance: Node2D = carriedShapeScene.instantiate()
	carriedShapeInstance.shape = producedShape
	carriedShapeInstance.position += offset
	
	# When bucket button released, drop softly.
	letGo.connect(carriedShapeInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedShapeInstance.dropFailure.connect(returnShape)
	
	# Randomize fetched rotation for flavor.
	cursor.rotation = randi_range(0,5) * deg_to_rad(60)
	
	cursor.add_child(carriedShapeInstance)
	print(carriedShapeInstance)
