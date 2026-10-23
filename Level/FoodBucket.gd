class_name FoodBucket extends Button

@export var stats: FoodItemStats
@export var producedShape: Array[Vector2i]
@export var grid: FoodGrid

@export var heldQuantity: int = 10

func _ready():
	if heldQuantity == 1:
		$Label.text = str(heldQuantity, " ", stats.foodItemName)
	else:
		$Label.text = str(heldQuantity, " ", stats.foodItemNamePlural)
	$Label.size = size

# Carried shape production.
const carriedFoodScene: Resource = preload("res://Level/FoodCarried.tscn")
func produceShape() -> void:
	# Create and initialize instance.
	var carriedFoodInstance: FoodCarried = carriedFoodScene.instantiate()
	carriedFoodInstance.shape = producedShape
	carriedFoodInstance.stats = stats
	carriedFoodInstance.tryDrop = grid.tryDrop
	carriedFoodInstance.grid = grid
	carriedFoodInstance.returnShape = returnShape
	
	# When unsuccessfully dropped, return to bucket.
	carriedFoodInstance.dropFailure.connect(returnShape)
	
	grid.find_child("Cursor").rotation = 0
	grid.find_child("Cursor").add_child(carriedFoodInstance)

# Increment quantity stored in bucket.
func returnShape():
	heldQuantity += 1
	if heldQuantity == 1:
		$Label.text = str(heldQuantity, " ", stats.foodItemName)
	else:
		$Label.text = str(heldQuantity, " ", stats.foodItemNamePlural)

# Decrement quantity stored in bucket and attempt to produce shape.
func _pressed() -> void:
	if (heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		if heldQuantity == 1:
			$Label.text = str(heldQuantity, " ", stats.foodItemName)
		else:
			$Label.text = str(heldQuantity, " ", stats.foodItemNamePlural)
		produceShape()
