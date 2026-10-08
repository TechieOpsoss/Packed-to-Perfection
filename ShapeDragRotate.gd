extends Polygon2D

var selected: bool = false
var triangle_rotation: int = 0
var grab_offset: Vector2 = Vector2.ZERO

# Graphical placement updates
var placed_internal: bool = false
var placed:
	set(val):
		if (val):
			placed_internal = true
			scale = Vector2.ONE
			color.a = 1
		else:
			placed_internal = false
			scale = Vector2(0.9,0.9)
			color.a = 0.5
	get:
		return placed_internal

func make_meshes(gridSpaceCellPositions: Array[Vector2i]) -> Array[PackedVector2Array]:
	var ret: Array[PackedVector2Array] = []
	for gridSpaceCellPosition: Vector2i in gridSpaceCellPositions:
		if ((gridSpaceCellPosition.x % 2) == (gridSpaceCellPosition.y % 2)):
			pass
	return ret

func combine_meshes(meshes: Array[PackedVector2Array]) -> Array:
	return []

@export var triangle_width: float = 128
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
	if ((gridSpace.x % 2) == (gridSpace.y % 2)):
		return Vector2(gridSpace) * triangle_grid_size - Vector2(0, verticalOffset)
	else:
		return Vector2(gridSpace) * triangle_grid_size + Vector2(0, verticalOffset)

func snap(to_snap: Vector2) -> Vector2:
	return grid_to_screen(screen_to_grid(to_snap, triangle_rotation % 2 == 1))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Move to random point on screen
	position = snap(Vector2(get_viewport().size / 2))
	# Get click events
	var clickArea: Area2D = find_child("ClickArea")
	clickArea.input_event.connect(_on_area_event)
	# Construct new polygon, centered on centroid TODO: multi-cellular
	polygon = PackedVector2Array([
		Vector2(-triangle_width/2,triangle_height-triangle_circumradius),
		Vector2(0,-triangle_circumradius),
		Vector2(triangle_width/2,triangle_height-triangle_circumradius)
	])
	# Copy polygon to clickArea's collision polygon
	var clickPolygon: CollisionPolygon2D = clickArea.find_child("CollisionShape")
	clickPolygon.polygon = polygon
	# Set other relevant info
	placed = false
	selected = true

func _on_area_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		selected = event.pressed
		# Snap on deselect TODO: multi-cellular TODO: gracefully keep selected
		if not placed and not selected and ShapeGlobal.CellViable(snap(position)):
			position = snap(position)
			ShapeGlobal.OccupiedCells.append(position)
			placed = true
			queue_redraw()
		# Un-occupy cell and update graphics on pickup TODO: multi-cellular
		if placed and selected:
			ShapeGlobal.OccupiedCells.remove_at(ShapeGlobal.OccupiedCells.find(position))
			placed = false
			grab_offset = position - get_viewport().get_mouse_position()

# Snap debug graphic
func _draw() -> void:
	draw_set_transform(Vector2.ZERO,-rotation,Vector2.ONE/scale)
	if not placed:
		draw_circle((snap(position)-position),6, Color(0,1,0,0.75))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if (selected):
		# Drag
		position = get_viewport().get_mouse_position() + grab_offset
		# Rotate TODO: rotate around grab point (offset under parent object?)
		if (Input.is_action_just_pressed("ui_right")):
			triangle_rotation = (triangle_rotation + 1) % 6
			rotation = triangle_rotation * deg_to_rad(60)
		if (Input.is_action_just_pressed("ui_left")):
			triangle_rotation = (triangle_rotation + 5) % 6
			rotation = triangle_rotation * deg_to_rad(60)
		# Draw snap debug graphic, in case position was updated
		queue_redraw()
