extends Node2D

@export var currentLevel: int
@export var levels: Array[Level]

signal completedAll

func _ready():
	if currentLevel < levels.size():
		loadLevel(levels[currentLevel])
	completedAll.connect($Level.queue_free)
	
	completedAll.connect(func():
		var endScreen = preload("res://Level/Scoring/FinalScore.tscn").instantiate()
		$Level/Container/ScoreCard.end_score(endScreen.find_child("Background").find_child("FinalScoreLabel"))
		get_tree().change_scene_to_node(endScreen)
	)
	LocalAudioManager.play_music("res://Audio/Music/Lunchbox.ogg", 0.5)

func loadLevel(level: Level):
	$Level/Container/ScoreCard.restrictions = level.restrictions
	$Level/Container/Grid.gridShape = level.gridShape.duplicate()
	$Level/Container/Grid.emptyCells = level.gridShape.duplicate()
	$Level/Container/Grid.clearDroppedFood()
	$Level/Container/Grid.requirements = level.restrictions
	$Level/Receipt.update($Level/Container/Grid.totalStats(), level.restrictions, level.customerName)
	$Level/Customer.texture = level.customerTexture
	
	$Level/Container/Grid.updateGridVisuals()
	if level.resetsFoodItems:
		$Level/Container/BucketTray/Bucket1.item = level.newItem1
		$Level/Container/BucketTray/Bucket1.heldQuantity = level.newItem1.foodStartQuantity
		$Level/Container/BucketTray/Bucket1.updateLabel()
			
		$Level/Container/BucketTray/Bucket2.item = level.newItem2
		$Level/Container/BucketTray/Bucket2.heldQuantity = level.newItem2.foodStartQuantity
		$Level/Container/BucketTray/Bucket2.updateLabel()
			
		$Level/Container/BucketTray/Bucket3.item = level.newItem3
		$Level/Container/BucketTray/Bucket3.heldQuantity = level.newItem3.foodStartQuantity
		$Level/Container/BucketTray/Bucket3.updateLabel()
			
		$Level/Container/BucketTray/Bucket4.item = level.newItem4
		$Level/Container/BucketTray/Bucket4.heldQuantity = level.newItem4.foodStartQuantity
		$Level/Container/BucketTray/Bucket4.updateLabel()
			
		$Level/Container/BucketTray/Bucket5.item = level.newItem5
		$Level/Container/BucketTray/Bucket5.heldQuantity = level.newItem5.foodStartQuantity
		$Level/Container/BucketTray/Bucket5.updateLabel()
			
		$Level/Container/BucketTray/Bucket6.item = level.newItem6
		$Level/Container/BucketTray/Bucket6.heldQuantity = level.newItem6.foodStartQuantity
		$Level/Container/BucketTray/Bucket6.updateLabel()
	$Level/Container/BucketTray/Bucket1.updateNutrients(level.restrictions)
	$Level/Container/BucketTray/Bucket2.updateNutrients(level.restrictions)
	$Level/Container/BucketTray/Bucket3.updateNutrients(level.restrictions)
	$Level/Container/BucketTray/Bucket4.updateNutrients(level.restrictions)
	$Level/Container/BucketTray/Bucket5.updateNutrients(level.restrictions)
	$Level/Container/BucketTray/Bucket6.updateNutrients(level.restrictions)

func _nextLevel():
	currentLevel += 1
	if currentLevel < levels.size():
		loadLevel(levels[currentLevel])
	else:
		completedAll.emit()
