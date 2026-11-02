extends Node2D

@export var currentLevel: int
@export var levels: Array[Level]

signal completedAll

func _ready():
	$LevelCounter.text = str(currentLevel + 1, "/", levels.size())
	if currentLevel < levels.size():
		loadLevel(levels[currentLevel])
	
	completedAll.connect(func():
		$Level/Container/BucketTray/SubmitButton.hide()
		var endScreen = preload("res://Level/Scoring/FinalScore.tscn").instantiate()
		$Level/Container/ScoreCard.end_score(endScreen.find_child("FinalScoreLabel"))
		await pop_out()
		down()
		await get_parent().down()
		get_parent().add_child(endScreen)
		get_parent().flicker_off()
		queue_free()
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
	
	$Level/Container/Grid.updateGridVisuals(level.trayTexture)
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
	$LevelCounter.text = str(currentLevel + 1, "/", levels.size())
	if currentLevel < levels.size():
		loadLevel(levels[currentLevel])
		summon_customer()
	else:
		completedAll.emit()

var summoned = false

func summon_customer():
	if not summoned:
		$Level/Customer.position.x = -576
	summoned = true
	while not is_queued_for_deletion() and summoned and $Level/Customer.position.x < 575:
		$Level/Customer.position.x = lerp($Level/Customer.position.x, 576.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion() and summoned:
		$Level/Customer.position.x = 576

func banish_customer():
	if summoned:
		$Level/Customer.position.x = 576
	summoned = false
	while not is_queued_for_deletion() and not summoned and $Level/Customer.position.x < 1168:
		$Level/Customer.position.x = lerp($Level/Customer.position.x, 2000.0, 0.01)
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion() and not summoned:
		$Level/Customer.position.x = -576

var popping_in = false

func pop_in():
	popping_in = true
	summon_customer()
	while not is_queued_for_deletion() and popping_in and $Level/Receipt.position.y < -1:
		$Level/Receipt.position.y = lerp($Level/Receipt.position.y, 0.0, 0.05)
		$LevelCounter.position.y = lerp($LevelCounter.position.y, 338.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion() and popping_in:
		$Level/Receipt.position.y = 0
		$LevelCounter.position.y = 338
		$Level/Hint._show()

func pop_out():
	popping_in = false
	while not is_queued_for_deletion() and not popping_in and $Level/Receipt.position.y > -359.0:
		$Level/Receipt.position.y = lerp($Level/Receipt.position.y, -360.0, 0.1)
		$LevelCounter.position.y = lerp($LevelCounter.position.y, -22.0, 0.1)
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion() and not popping_in:
		$Level/Receipt.position.y = -1008
		$LevelCounter.position.y = -670

func down():
	while not is_queued_for_deletion() and position.y < 345:
		position.y = lerp(position.y, 345.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion():
		position.y = 345

func up():
	while not is_queued_for_deletion() and position.y > 151:
		position.y = lerp(position.y, 150.0, 0.05)
		await get_tree().create_timer(0.01).timeout
	if not is_queued_for_deletion():
		position.y = 150
