extends Button

@export var shape: Array[Vector2i] = [Vector2i(0,0)]
signal produceShape(shape: Array[Vector2i], offset: Vector2, softDrop: Signal, returnShape: Callable)

@export var quantity: int = 10

func returnShape():
	quantity += 1
	print("Quantity: ", quantity)

func _pressed() -> void:
	if (quantity > 0):
		quantity = quantity - 1
		print("Quantity: ", quantity)
		produceShape.emit(shape, Vector2(0,0), button_up, returnShape)
