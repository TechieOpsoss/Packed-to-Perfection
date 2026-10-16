extends Node2D

@export var aliens: Array[Alien]
@export var alien_scene: PackedScene
@export var alien_container: Node2D

# Called when the node enters the scene tree for the first time.


func choose_alien():
	var num_aliens = aliens.size()
	var rand_alien = randi() % num_aliens
	var alien_data = aliens[rand_alien]
	#for child in alien_container.get_children(): #this should be moved for when switching to new alien within the level
		#child.queue_free()
	var alien = alien_scene.instantiate()
	alien_container.add_child(alien)
	alien.setup(alien_data)
	print("Alien added to tree!")
	$AlienContainer/ReceiptLayer.create_receipt(alien)


func _ready() -> void:
	choose_alien()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
