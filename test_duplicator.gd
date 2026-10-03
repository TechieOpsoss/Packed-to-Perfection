extends Polygon2D

func upper_left_most(a, b) -> bool:
	return (a.position.x + a.position.y < b.position.x + b.position.y)

func _on_button_event(viewport: Node, event: InputEvent, shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		var newTriangle = load("res://PrototypeShape.tscn").instantiate()
		get_parent().add_child(newTriangle)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_child("ButtonArea").input_event.connect(_on_button_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
