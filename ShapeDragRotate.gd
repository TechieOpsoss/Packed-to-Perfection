extends Polygon2D

var placed: bool = false
var selected: bool = false
var triRotation: int = 0

func set_placed():
	placed = true
	scale = Vector2(1,1)
	color.a = 1
func set_unplaced():
	placed = false
	scale = Vector2(0.75,0.75)
	color.a = 0.5

func _init() -> void:
	pass

@export var triangle_width: float = 32
var triangle_height: float = triangle_width * sin(deg_to_rad(60))
var triangle_circumradius: float = triangle_width / sqrt(3)
var triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
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
	# Construct new polygon, centered on centroid
	polygon = PackedVector2Array([
		Vector2(-triangle_width/2,triangle_height-triangle_circumradius),
		Vector2(0,-triangle_circumradius),
		Vector2(triangle_width/2,triangle_height-triangle_circumradius)
	])
	# Copy polygon to clickArea's collision polygon
	var clickPolygon: CollisionPolygon2D = clickArea.find_child("CollisionShape")
	clickPolygon.polygon = polygon
	# Set other relevant info
	set_unplaced()

func _on_area_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		# Prevent pickup of full stack when overlapping
		if (!selected and event.pressed):
			for sibling in get_parent().get_children():
				if (sibling.position == position and sibling.selected):
					return
		
		selected = event.pressed
		# Snap on deselect
		if not placed and not selected and ShapeGlobal.CellViable(snap(position)):
			position = snap(position)
			ShapeGlobal.OccupiedCells.append(position)
			set_placed()
			queue_redraw()
		if placed and selected:
			ShapeGlobal.OccupiedCells.remove_at(ShapeGlobal.OccupiedCells.find(position))
			set_unplaced()

# Snap debug graphic
func _draw() -> void:
	draw_set_transform(Vector2(0,0),-rotation,Vector2(1,1)/scale)
	if not placed:
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
