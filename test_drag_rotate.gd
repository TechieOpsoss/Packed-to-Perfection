extends Polygon2D

var selected: bool = false
var triRotation: int = 0

func _init() -> void:
	pass

const triangle_width: float = 32
const triangle_height: float = triangle_width * sin(deg_to_rad(60))
const triangle_circumradius: float = triangle_width / sqrt(3)
const triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
func screen_to_grid(screenSpace: Vector2, pointsDown: bool) -> Vector2i:
	# Find nearest cell (centroid)
	var cellY: int = round(screenSpace.y / triangle_grid_size.y)
	# Horizontally offset grid snap if on an odd row, or upside down
	var horizontalOffset: int = (1 if ((cellY % 2 == 0) != pointsDown) else 0)
	var cellX: int = round((float(screenSpace.x)/triangle_grid_size.x + horizontalOffset)/2.0)*2 - horizontalOffset
	return Vector2i(cellX, cellY)

func grid_to_screen(gridSpace: Vector2i) -> Vector2:
	# Offset to be vertically centered based on height rather than centroid
	var verticalOffset: float = triangle_circumradius - triangle_height / 2
	if (fmod(gridSpace.x, 2) == fmod(gridSpace.y, 2)):
		return Vector2(gridSpace) * triangle_grid_size - Vector2(0, verticalOffset)
	else:
		return Vector2(gridSpace) * triangle_grid_size + Vector2(0, verticalOffset)

func snap(to_snap: Vector2) -> Vector2:
	return grid_to_screen(screen_to_grid(to_snap, triRotation % 2 == 0))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Move to random point on screen
	position = snap(Vector2(get_viewport().size / 2))
	# Get click events
	var clickArea: Area2D = find_child("ClickArea")
	clickArea.input_event.connect(_on_area_event)
	var clickPolygon: CollisionPolygon2D = clickArea.find_child("CollisionShape")
	clickPolygon.polygon = polygon

func _on_area_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		# Prevent pickup of full stack when overlapping
		if (!selected and event.pressed):
			for sibling in get_parent().get_children():
				if (sibling.position == position and sibling.selected):
					return
		
		selected = event.pressed
		# Snap on deselect
		if (!selected):
			position = snap(position)
			queue_redraw()

# Snap debug graphic
func _draw() -> void:
	draw_set_transform(Vector2(0,0),-rotation,Vector2(1,1)/scale)
	draw_circle((snap(position)-position),6, Color(0,1,0,0.75))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (selected):
		# Drag
		position = get_viewport().get_mouse_position()
		# Rotate
		if (Input.is_action_just_pressed("ui_right")):
			triRotation = triRotation + 1 % 6
			rotation = triRotation * deg_to_rad(60)
		if (Input.is_action_just_pressed("ui_left")):
			triRotation = triRotation + 5 % 6
			rotation = triRotation * deg_to_rad(60)
		# Draw snap debug graphic, in case position was updated
		queue_redraw()
