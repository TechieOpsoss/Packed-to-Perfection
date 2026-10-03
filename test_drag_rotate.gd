extends Polygon2D

var selected: bool = false
var triRotation: int = 0

func _init() -> void:
	pass

func snap(to_snap: Vector2) -> Vector2:
	var snap_to: Vector2
	# Snap to nearest grid space, with half triangle width
	snap_to = Vector2(16, 27.7128129211)
	var snapped: Vector2 = round(to_snap / snap_to)
	# Offset grid snap if on an odd row, or upside down
	if (fmod(snapped.y,2) == (triRotation % 2)):
		snapped.x += 1
	snapped.x = round(snapped.x / 2)
	if (fmod(snapped.y,2) == (triRotation % 2)):
		snapped.x -= 0.5
	# Transform from snapped grid space to world space
	snapped *= snap_to * Vector2(2,1)
	# Offset to be vertically centered based on height rather than centroid
	if ((triRotation % 2) == 0):
		snapped.y += 4.61880215352
	else:
		snapped.y -= 4.61880215352
	
	return snapped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Move to center of screen
	position = snap((Vector2(get_viewport().size) * Vector2(randf_range(0,1),randf_range(0,1))))
	# Get click events
	var clickArea: Area2D = find_child("Area2D")
	clickArea.input_event.connect(_on_area_event)

func _on_area_event(viewport: Node, event: InputEvent, shape_idx: int):
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
func _process(delta: float) -> void:
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
