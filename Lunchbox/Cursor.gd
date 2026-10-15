# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move to cursor position.
	position = get_viewport().get_mouse_position()
	if (Input.is_action_just_pressed("ui_right")):
		rotation = fmod(rotation + deg_to_rad(60), deg_to_rad(360))
	if (Input.is_action_just_pressed("ui_left")):
		rotation = fmod(rotation + deg_to_rad(300), deg_to_rad(360))
	pass

# Carried shape production.
const carriedShapeScene: Resource = preload("res://Lunchbox/CarriedShape.tscn")
func produceShape(shape: Array[Vector2i], offset: Vector2, letGo: Signal, returnShape: Callable):
	# Create and initialize instance.
	var carriedShapeInstance: Node2D = carriedShapeScene.instantiate()
	carriedShapeInstance.shape = shape
	carriedShapeInstance.position += offset
	
	# When bucket button released, drop softly.
	letGo.connect(carriedShapeInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedShapeInstance.dropFailure.connect(returnShape)
	
	# Randomize fetched rotation for flavor.
	rotation = randi_range(0,5) * deg_to_rad(60)
	
	add_child(carriedShapeInstance)
