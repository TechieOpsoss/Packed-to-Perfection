extends Node2D

@export var aliens: Array[Alien]
@export var alien_scene: PackedScene
@export var alien_container: Node2D
var prev_aliens: Array[int] #holds previous aliens in level
const MAX_ALIENS = 3 # max number of aliens for level 1
var total_aliens = 0
var current_alien: Node2D
signal end_level()

func choose_alien():
	var num_aliens = aliens.size()
	var rand_alien = randi() % num_aliens
	# TODO add in check to see if puzzle is still solvable with given alien, may be better to only add in Aliens usable for the level and put other aliens in another level to reduce checking
	var alien_data = aliens[rand_alien]
	aliens.remove_at(rand_alien) #remove alien to not be selected again
	print("Alien array: ", aliens)
	return alien_data

func changeAlien() -> void:
	#TODO need to reset grid/lunchbox
	if(total_aliens < MAX_ALIENS):
		if is_instance_valid(current_alien):
			current_alien.queue_free()
		var data = choose_alien()
		var alien = alien_scene.instantiate()
		alien_container.add_child(alien)
		alien.setup(data)
		print("Alien added to tree!")
		total_aliens += 1
		$AlienContainer/ReceiptLayer.create_receipt(alien)
		$UI.get_alien(alien)
		current_alien = alien
	else:
		end_level.emit()
		#emit end level
		pass

func _ready() -> void:
	print("total aliens: ", total_aliens)
	$UI.select_alien.connect(changeAlien)
	changeAlien()
