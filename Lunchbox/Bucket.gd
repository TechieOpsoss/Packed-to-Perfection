extends Button

@export var shape: Array[Vector2i] = [Vector2i(0,0)]
signal produceShape(shape: Array[Vector2i])

@export var quantity: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	if (quantity > 0):
		quantity = quantity - 1
		produceShape.emit(shape)
