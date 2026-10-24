class_name FoodBucket extends Button

@export var item: FoodItem
@export var grid: FoodGrid

var heldQuantity: int

func updateText():
	if heldQuantity == 1:
		$Label.text = str(heldQuantity, " ", item.foodItemName, "\n", item.stats)
	else:
		$Label.text = str(heldQuantity, " ", item.foodItemNamePlural, "\n", item.stats)

func _ready():
	heldQuantity = item.foodStartQuantity
	updateText()
	$Label.size = size

# Carried shape production.
const carriedFoodScene: Resource = preload("res://Level/Food/FoodCarried.tscn")
func produceShape() -> void:
	# Create and initialize instance.
	var carriedFoodInstance: FoodCarried = carriedFoodScene.instantiate()
	carriedFoodInstance.item = item
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
	updateText()

# Decrement quantity stored in bucket and attempt to produce shape.
func _pressed() -> void:
	if (heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		updateText()
		produceShape()
