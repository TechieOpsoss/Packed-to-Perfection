class_name FoodBucket extends Button

@export var item: FoodItem
@export var grid: FoodGrid

var heldQuantity: int

func updateLabel():
	if heldQuantity == 1:
		$Label.text = str(heldQuantity, " ", item.foodItemName)
	else:
		$Label.text = str(heldQuantity, " ", item.foodItemNamePlural)
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(item.shape, 12, 4))
	$PreviewShape.polygon = verticesAndIndices[0]
	$PreviewShape.polygons = verticesAndIndices[1]
	var minBounds: Vector2 = verticesAndIndices[0][0]
	for vertex in verticesAndIndices[0]:
		minBounds.x = min(minBounds.x, vertex.x)
		minBounds.y = min(minBounds.y, vertex.y)
	$PreviewShape.position = -minBounds + Vector2(4,4)

func updateNutrients(requirements: FoodItemStats):
	pass

func _ready():
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
	updateLabel()

# Decrement quantity stored in bucket and attempt to produce shape.
func _pressed() -> void:
	if (heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		updateLabel()
		produceShape()
