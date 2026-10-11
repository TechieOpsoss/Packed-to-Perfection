@tool #helps me see the circle in editor
extends Polygon2D

@export var shape: Array[Vector2i]
@export var radius: float = 250.0
@export var num_points: int = 60

func upper_left_most(a, b) -> bool:
	return (a.position.x + a.position.y < b.position.x + b.position.y)

func _on_button_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		print("Left click detected!")
		var newTriangle = load("res://PrototypeShape.tscn").instantiate()
		newTriangle.shape = shape
		get_parent().add_child(newTriangle)

# draws circle for bucket
func draw_circle_polygon():
	var points = PackedVector2Array()
	for i in range(num_points):
		var angle = i * float(2 * PI) / num_points
		var x = cos(angle) * radius
		var y = sin(angle) * radius
		points.append(Vector2(x, y))
		
	self.polygon = points

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	draw_circle_polygon()
	find_child("ButtonArea").input_event.connect(_on_button_event)
	find_child("ButtonArea").find_child("CollisionPolygon2D").polygon = polygon
	print(find_child("ButtonArea").find_child("CollisionPolygon2D").polygon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
