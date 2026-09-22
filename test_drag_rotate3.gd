extends Node2D

var selected: bool = false
var triRotation: int = 0

func _init() -> void:
	pass

func snap(to_snap: Vector2) -> Vector2:
	var snap_to: Vector2
	snap_to = Vector2(16, 27.7128129211)
	var snapped: Vector2 = round(to_snap / snap_to)
	if (fmod(snapped.y,2) == (triRotation % 2)):
		snapped.x += 1
	snapped.x = round(snapped.x / 2)
	if (fmod(snapped.y,2) == (triRotation % 2)):
		snapped.x -= 0.5
	snapped *= snap_to * Vector2(2,1)
	if ((triRotation % 2) == 0):
		snapped.y += 4.61880215352
	else:
		snapped.y -= 4.61880215352
	return snapped

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get click events
	var clickArea: Area2D = find_child("Area2D")
	clickArea.input_event.connect(_on_area_event)

func _on_area_event(viewport: Node, event: InputEvent, shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		selected = event.pressed
		# Snap
		if (!selected):
			position = snap(position)
			queue_redraw()

func _draw() -> void:
	draw_set_transform(Vector2(0,0),-rotation,Vector2(1,1)/scale)
	draw_circle((snap(position)-position),1, Color.GREEN)

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
		# Draw
		queue_redraw()
