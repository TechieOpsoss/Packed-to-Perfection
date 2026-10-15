# Attached to blank node that acts as cursor and carries shapes.
extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Move to cursor position.
	position = get_viewport().get_mouse_position()
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
	
	add_child(carriedShapeInstance)
