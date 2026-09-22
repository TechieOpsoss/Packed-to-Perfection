extends Polygon2D

var replicationArea: Area2D = null

func upper_left_most(a, b) -> bool:
	return (a.position.x + a.position.y < b.position.x + b.position.y)

func _on_button_event(viewport: Node, event: InputEvent, shape_idx: int):
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		print("click!")
		var sortedBodies = replicationArea.get_overlapping_bodies().duplicate()
		sortedBodies.sort_custom(upper_left_most)
		
		var polygon = load("res://Prototype3Polygon.tscn").instantiate()
		var needsPosition: bool = true
		
		var bodyParts = 0
		for body in sortedBodies:
			if (needsPosition):
				polygon.position = body.get_parent().position + Vector2(384, 0)
				needsPosition = false
			
			if (body.get_parent() is Polygon2D):
				var dupe: Node2D = body.get_parent().duplicate()
				dupe.name = str(bodyParts)
				dupe.set_script(null)
				
				dupe.position -= polygon.position - Vector2(384, 0)
				
				polygon.find_child("Parts").add_child(dupe)
				bodyParts += 1
			elif (body.get_parent().find_child("Parts") != null):
				for part in body.get_parent().find_child("Parts").get_children():
					var dupe: Node2D = part.duplicate()
					dupe.name = str(bodyParts)
					
					dupe.position = dupe.position + body.get_parent().position - (polygon.position - Vector2(384, 0))
					
					polygon.find_child("Parts").add_child(dupe)
					bodyParts += 1
		get_parent().add_child(polygon)
		print(bodyParts)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	replicationArea = find_child("ReplicationArea")
	find_child("ButtonArea").input_event.connect(_on_button_event)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
