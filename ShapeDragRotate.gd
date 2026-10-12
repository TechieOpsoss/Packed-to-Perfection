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

@export var triangle_width: float = 64
@export var visual_width: float = 63
@export var shape: Array[Vector2i] = [Vector2i(0,0)]
var triangle_height: float = triangle_width * sin(deg_to_rad(60))
var triangle_circumradius: float = triangle_width / sqrt(3)
var triangle_grid_size: Vector2 = Vector2(triangle_width / 2, triangle_height)
var visual_height: float = visual_width * sin(deg_to_rad(60))
var visual_circumradius: float = visual_width / sqrt(3)
func make_meshes(gridSpaceCellPositions: Array[Vector2i]) -> Array[PackedVector2Array]:
	var ret: Array[PackedVector2Array] = []
	for gridSpaceCellPosition: Vector2i in gridSpaceCellPositions:
		if ((gridSpaceCellPosition.x % 2) == (gridSpaceCellPosition.y % 2)):
			ret.append(PackedVector2Array(
			[
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(-visual_width/2,visual_height-visual_circumradius),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(0,-visual_circumradius),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(visual_width/2,visual_height-visual_circumradius)
			]))
		else:
			var verticalOffset: float = triangle_circumradius - triangle_height / 2
			ret.append(PackedVector2Array(
			[
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(-visual_width/2,visual_circumradius-visual_height) - Vector2(0, verticalOffset*2),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(0,visual_circumradius) - Vector2(0, verticalOffset*2),
				Vector2(gridSpaceCellPosition) * triangle_grid_size + Vector2(visual_width/2,visual_circumradius-visual_height) - Vector2(0, verticalOffset*2)
			]))
	return ret

func combine_meshes(meshes: Array[PackedVector2Array]) -> Array:
	var ret1: PackedVector2Array = []
	var ret2: Array[PackedInt32Array] = []
	for triangleMesh: PackedVector2Array in meshes:
		ret2.append(PackedInt32Array([ret1.size(), ret1.size() + 1, ret1.size() + 2]))
		ret1.append_array(triangleMesh)
	return [ret1, ret2]

func change_shape(gridSpaceCellPositions: Array[Vector2i]):
	var clickArea: Area2D = find_child("ClickArea")
	# Construct new polygons, with (0,0) centered on centroid
	var cellMeshes = make_meshes(gridSpaceCellPositions)
	var combinedMeshes = combine_meshes(cellMeshes)
	polygon = combinedMeshes[0]
	polygons = combinedMeshes[1]
	# Delete old collision polygons
	for existingPolygon: CollisionPolygon2D in clickArea.find_children("*","CollisionPolygon2D",false):
		existingPolygon.queue_free()
	# Create new collision polygons
	for mesh: PackedVector2Array in cellMeshes:
		var clickPolygon: CollisionPolygon2D = CollisionPolygon2D.new()
		clickArea.add_child(clickPolygon)
		clickPolygon.polygon = mesh
	

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
	change_shape(shape)
	# Set other relevant info
	placed = false
	selected = true

func _on_area_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	# Un-occupy cell and update graphics on pickup
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) and (placed and not selected and event.pressed):
		ShapeGlobal.OccupiedCells.remove_at(ShapeGlobal.OccupiedCells.find(position))
		placed = false
		selected = true
		grab_offset = position - get_viewport().get_mouse_position()
		queue_redraw()
func _unhandled_input(event):
	# Snap on deselect
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT) and (not placed and selected and not event.pressed and ShapeGlobal.CellViable(snap(position))):
		position = snap(position)
		ShapeGlobal.OccupiedCells.append(position)
		placed = true
		selected = false
		queue_redraw()

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
