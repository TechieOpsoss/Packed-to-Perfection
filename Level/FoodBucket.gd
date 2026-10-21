extends Button

@export var foodItemName: String
@export var foodItemNamePlural: String
@export var shape: Array[Vector2i]
signal produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable)

@export var heldQuantity: int = 10

func _ready():
	if heldQuantity == 1:
		tooltip_text = str(heldQuantity, " ", foodItemName)
	else:
		tooltip_text = str(heldQuantity, " ", foodItemNamePlural)

# Increment quantity stored in bucket.
func returnShape():
	heldQuantity += 1
	if heldQuantity == 1:
		tooltip_text = str(heldQuantity, " ", foodItemName)
	else:
		tooltip_text = str(heldQuantity, " ", foodItemNamePlural)

# Decrement quantity stored in bucket and attempt to produce shape.
func _pressed() -> void:
	if (heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		if heldQuantity == 1:
			tooltip_text = str(heldQuantity, " ", foodItemName)
		else:
			tooltip_text = str(heldQuantity, " ", foodItemNamePlural)
		produceShape.emit(shape, Vector2(0,0), button_up, returnShape)
