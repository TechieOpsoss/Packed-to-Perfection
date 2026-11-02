class_name FoodBucket extends Button

@export var item: FoodItem
@export var grid: FoodGrid

var heldQuantity: int

func updateLabel():
	$Label.text = str(heldQuantity)
	#if heldQuantity == 1:
	#	$Label.text = str(heldQuantity, " ", item.foodItemName)
	#else:
	#	$Label.text = str(heldQuantity, " ", item.foodItemNamePlural)
	var tris: Array[PackedVector2Array] = TriGridUtils.make_meshes(item.shape, 32, 3)
	var minVertexBounds = tris[0][0]
	var maxVertexBounds = tris[0][0]
	for tri in tris:
		for vertex in tri:
			minVertexBounds.x = min(minVertexBounds.x, vertex.x)
			minVertexBounds.y = min(minVertexBounds.y, vertex.y)
			maxVertexBounds.x = max(maxVertexBounds.x, vertex.x)
			maxVertexBounds.y = max(maxVertexBounds.y, vertex.y)
	var shapeSize = maxVertexBounds - minVertexBounds
	var textureSize = item.texture.get_size()
	var maxRatio = max(shapeSize.x, shapeSize.y) / max(textureSize.x, textureSize.y)
	$Visual.scale = Vector2(maxRatio, maxRatio)
	$Visual.texture = item.texture
	$Visual.position = Vector2(48,48)#Vector2(48 - (maxVertexBounds.x + minVertexBounds.x) / 2,48 - (maxVertexBounds.y + minVertexBounds.y) / 2) + (minVertexBounds + maxVertexBounds) / 2
	
	var verticesAndIndices = TriGridUtils.combine_meshes(tris)
	$PreviewShape.polygon = verticesAndIndices[0]
	$PreviewShape.polygons = verticesAndIndices[1]
	$PreviewShape.color = item.color * Color(1,1,1,0.8)
	$PreviewShape.position = Vector2(48 - (maxVertexBounds.x + minVertexBounds.x) / 2,48 - (maxVertexBounds.y + minVertexBounds.y) / 2)

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


func _on_hover() -> void:
	$PreviewShape.visible = true


func _on_unhover() -> void:
	$PreviewShape.visible = false
