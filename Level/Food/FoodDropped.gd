class_name FoodProducer extends Area2D

@export var foodStats: FoodItemStats
@export var producerShape: Array[Vector2i]
@export var producedShape: Array[Vector2i]
@export var triangleWidth: float
@export var cellSpacing: float
@export var grid: FoodGrid
@export var returnShape: Callable

@export var heldQuantity: int = 1

signal depleted()

func _ready():
	input_event.connect(onInputEvent)
	# Shape setting
	var polygons: Array[PackedVector2Array] = TriGridUtils.make_meshes(producerShape, triangleWidth, cellSpacing)
	var verticesAndIndices = TriGridUtils.combine_meshes(polygons)
	$Visual.polygon = verticesAndIndices[0]
	$Visual.polygons = verticesAndIndices[1]
	for polygon in polygons:
		var collisionPolygon: CollisionPolygon2D = CollisionPolygon2D.new()
		collisionPolygon.polygon = polygon
		add_child(collisionPolygon)
	depleted.connect(queue_free)

# Carried shape production.
const carriedFoodScene: Resource = preload("res://Level/Food/FoodCarried.tscn")
func produceShape():
	# Create and initialize instance.
	var carriedFoodInstance: FoodCarried = carriedFoodScene.instantiate()
	carriedFoodInstance.shape = producedShape
	carriedFoodInstance.stats = foodStats
	carriedFoodInstance.tryDrop = grid.tryDrop
	carriedFoodInstance.grid = grid
	carriedFoodInstance.returnShape = returnShape
	
	# When unsuccessfully dropped, return to producer.
	carriedFoodInstance.dropFailure.connect(returnShape)
	
	grid.find_child("Cursor").rotation = 0
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
