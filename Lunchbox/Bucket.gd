extends Button

@export var shape: Array[Vector2i] = []
signal produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable)

@export var heldQuantity: int = 10

# Increment quantity stored in bucket.
func returnShape():
	heldQuantity += 1
	print(heldQuantity)

# Decrement quantity stored in bucket and attempt to produce shape.
func _pressed() -> void:
	if (heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		print(heldQuantity)
		produceShape.emit(shape, Vector2(0,0), button_up, returnShape)
