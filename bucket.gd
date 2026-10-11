extends Sprite2D

@export var shape: Array[Vector2i]
func upper_left_most(a, b) -> bool:
	return (a.position.x + a.position.y < b.position.x + b.position.y)

func _on_button_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		var newTriangle = load("res://PrototypeShape.tscn").instantiate()
		newTriangle.shape = shape
		get_parent().add_child(newTriangle)

func _draw() -> void:
	var circle_points = generate_circle_polygon(250.0,50, Vector2(180, 180))
	for i in range(circle_points.size()):
		var next_point = (i + 1) % circle_points.size()
		draw_line(circle_points[i], circle_points[next_point], Color.AQUA)

func generate_circle_polygon(radius: float, num_sides: int, position: Vector2) -> PackedVector2Array:
	var angle_delta: float = (PI * 2) / num_sides
	var vector: Vector2 = Vector2(radius, 0)
	var polygon: PackedVector2Array
	for i in num_sides:
		polygon.append(vector + position)
		vector = vector.rotated(angle_delta)
	return polygon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	find_child("ButtonArea").input_event.connect(_on_button_event)
	find_child("ButtonArea").find_child("CollisionPolygon2D").polygon = generate_circle_polygon(250.0,50, Vector2(180, 180))
	print(find_child("ButtonArea").find_child("CollisionPolygon2D").polygon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
