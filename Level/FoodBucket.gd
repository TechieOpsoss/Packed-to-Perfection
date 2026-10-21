class_name FoodBucket extends Button

var foodItem: Scoring.FoodItemStats
@export var foodItemName: String
@export var foodItemNamePlural: String
@export var shape: Array[Vector2i]
@export var grid: FoodGrid
#signal produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable)


# Carried shape production.
const carriedFoodScene: Resource = preload("res://Level/FoodCarried.tscn")
func produceShape(producedShape: Array[Vector2i], cursorOffset: Vector2, letGoFromBucket: Signal, returnToBucket: Callable):
	# Create and initialize instance.
	var carriedFoodInstance: FoodCarried = carriedFoodScene.instantiate()
	carriedFoodInstance.shape = producedShape
	carriedFoodInstance.position += cursorOffset
	
	carriedFoodInstance.tryDrop = grid.tryDrop
	carriedFoodInstance.grid = grid
	
	# When bucket button released, drop softly.
	letGoFromBucket.connect(carriedFoodInstance.dropSoft)
	
	# When unsuccessfully dropped, return to bucket.
	carriedFoodInstance.dropFailure.connect(returnToBucket)
	
	# Reset fetched rotation for consistency.
	$Cursor.rotation = 0
	
	$Cursor.add_child(carriedFoodInstance)

@export var heldQuantity: int = 10

func _ready():
	if heldQuantity == 1:
		tooltip_text = str(heldQuantity, " ", foodItemName)
		$Label.text = str(heldQuantity, " ", foodItemName)
	else:
		tooltip_text = str(heldQuantity, " ", foodItemNamePlural)
		$Label.text = str(heldQuantity, " ", foodItemNamePlural)
	$Label.size = size

# Increment quantity stored in bucket.
func returnShape():
	heldQuantity += 1
	if heldQuantity == 1:
		tooltip_text = str(heldQuantity, " ", foodItemName)
		$Label.text = str(heldQuantity, " ", foodItemName)
	else:
		tooltip_text = str(heldQuantity, " ", foodItemNamePlural)
		$Label.text = str(heldQuantity, " ", foodItemNamePlural)

# Decrement quantity stored in bucket and attempt to produce shape.
func _pressed() -> void:
	if (heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		if heldQuantity == 1:
			tooltip_text = str(heldQuantity, " ", foodItemName)
			$Label.text = str(heldQuantity, " ", foodItemName)
		else:
			tooltip_text = str(heldQuantity, " ", foodItemNamePlural)
			$Label.text = str(heldQuantity, " ", foodItemNamePlural)
		produceShape(shape, Vector2(0,0), button_up, returnShape)
