class_name FoodProducer extends Area2D

@export var item: FoodItem
@export var triangleWidth: float
@export var cellSpacing: float
@export var grid: FoodGrid
@export var returnShape: Callable

@export var heldQuantity: int = 1

signal depleted()

func _ready():
	input_event.connect(onInputEvent)
	# Shape setting
	#var verticesAndIndices = TriGridUtils.combine_meshes(TriGridUtils.make_meshes(item.shape, triangleWidth, cellSpacing))
	#$ReferenceVisual.polygon = verticesAndIndices[0]
	#$ReferenceVisual.polygons = verticesAndIndices[1]
	#$ReferenceVisual.color = item.color
	var tris: Array[PackedVector2Array] = TriGridUtils.make_meshes(item.shape, triangleWidth, 0)
	var minVertexBounds = tris[0][0]
	var maxVertexBounds = tris[0][0]
	for tri in tris:
		for vertex in tri:
			minVertexBounds.x = min(minVertexBounds.x, vertex.x)
			minVertexBounds.y = min(minVertexBounds.y, vertex.y)
			maxVertexBounds.x = max(maxVertexBounds.x, vertex.x)
			maxVertexBounds.y = max(maxVertexBounds.y, vertex.y)
		var collisionPolygon: CollisionPolygon2D = CollisionPolygon2D.new()
		collisionPolygon.polygon = tri
		add_child(collisionPolygon)
	var shapeSize = maxVertexBounds - minVertexBounds
	var textureSize = item.texture.get_size()
	var maxRatio = max(shapeSize.x, shapeSize.y) / max(textureSize.x, textureSize.y)
	$Visual.scale = Vector2(maxRatio, maxRatio)
	$Visual.texture = item.texture
	$Visual.position = (minVertexBounds + maxVertexBounds) / 2
	depleted.connect(queue_free)

# Carried shape production.
const carriedFoodScene: Resource = preload("res://Level/Food/FoodCarried.tscn")
func produceShape():
	# Create and initialize instance.
	var carriedFoodInstance: FoodCarried = carriedFoodScene.instantiate()
	carriedFoodInstance.item = item
	carriedFoodInstance.tryDrop = grid.tryDrop
	carriedFoodInstance.grid = grid
	carriedFoodInstance.returnShape = returnShape
	
	# When unsuccessfully dropped, return to producer.
	carriedFoodInstance.dropFailure.connect(returnShape)
	
	# Make pickup more consistent and feel niceys
	grid.find_child("Cursor").rotation = rotation
	carriedFoodInstance.position = (position - grid.find_child("Cursor").position).rotated(-rotation)
	
	grid.find_child("Cursor").add_child(carriedFoodInstance)
	
	return carriedFoodInstance

# Decrement quantity stored in producer and attempt to produce shape.
func onInputEvent(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and heldQuantity > 0:
		heldQuantity = heldQuantity - 1
		if heldQuantity == 0:
			depleted.emit()
		produceShape()
		get_viewport().set_input_as_handled()
