class_name FoodBucket extends Button

@export var item: FoodItem
@export var grid: FoodGrid

var minPreviewBounds: Vector2
var maxPreviewBounds: Vector2
var heldQuantity: int

func updateLabel():
	if heldQuantity == 1:
		$Label.text = str(heldQuantity, " ", item.foodItemName)
	else:
		$Label.text = str(heldQuantity, " ", item.foodItemNamePlural)
	var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(item.shape, 24, 3))
	$PreviewShape.polygon = verticesAndIndices[0]
	$PreviewShape.polygons = verticesAndIndices[1]
	minPreviewBounds = verticesAndIndices[0][0]
	maxPreviewBounds = verticesAndIndices[0][0]
	for vertex in verticesAndIndices[0]:
		minPreviewBounds.x = min(minPreviewBounds.x, vertex.x)
		minPreviewBounds.y = min(minPreviewBounds.y, vertex.y)
		maxPreviewBounds.x = max(maxPreviewBounds.x, vertex.x)
		maxPreviewBounds.y = max(maxPreviewBounds.y, vertex.y)
	$PreviewShape.position = Vector2(48 - (maxPreviewBounds.x + minPreviewBounds.x) / 2,48 - (maxPreviewBounds.y + minPreviewBounds.y) / 2)

func updateNutrients(requirements: FoodItemStats):
	$StatDisplay.update(item.stats, requirements)

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
	if (Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_LEFT != 0 and heldQuantity > 0):
		heldQuantity = heldQuantity - 1
		updateLabel()
		produceShape()
	if (Input.get_mouse_button_mask() & MOUSE_BUTTON_MASK_RIGHT != 0):
		$StatDisplay.visible = !$StatDisplay.visible
		$PreviewShape.visible = !$StatDisplay.visible
