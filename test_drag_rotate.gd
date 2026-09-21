extends Sprite2D

var selected: bool = false
var clickShape: CollisionShape2D = null

func _init() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Move to center of screen
	position = get_viewport().size / 2
	# Get click events
	var clickArea = find_child("Area2D")
	clickArea.input_event.connect(_on_area_event)
	# Resize click area to fit around sprite
	clickShape = clickArea.find_child("CollisionShape2D")
	clickShape.shape.size.x = texture.get_width()
	clickShape.shape.size.y = texture.get_height()

func _on_area_event(viewport: Node, event: InputEvent, shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		selected = event.pressed
		# Snap
		if (!selected):
			var size = Vector2(texture.get_width(), texture.get_height())
			position = size * round(position / size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (selected):
		# Drag
		position = get_viewport().get_mouse_position()
		# Rotate
		if (Input.is_action_just_pressed("ui_right")):
			rotation += deg_to_rad(90)
		if (Input.is_action_just_pressed("ui_left")):
			rotation -= deg_to_rad(90)
