extends Node2D

@export var currentLevel: int
@export var levels: Array[Level]

signal completedAll

func _ready():
	if currentLevel < levels.size():
		loadLevel(levels[currentLevel])
	completedAll.connect($Level.queue_free)

func loadLevel(level: Level):
	$Level/ScoreCard.restrictions = level.restrictions
	$Level/Grid.gridShape = level.gridShape.duplicate()
	$Level/Grid.emptyCells = level.gridShape.duplicate()
	$Level/Grid.clearDroppedFood()
	
	$Level/Grid.updateGridVisuals()
	if level.resetsFoodItems:
		$Level/BucketTray/Bucket1.item = level.newItem1
		$Level/BucketTray/Bucket1.heldQuantity = level.newItem1.foodStartQuantity
		if $Level/BucketTray/Bucket1.heldQuantity == 1:
			$Level/BucketTray/Bucket1/Label.text = str($Level/BucketTray/Bucket1.heldQuantity, " ", level.newItem1.foodItemName)
		else:
			$Level/BucketTray/Bucket1/Label.text = str($Level/BucketTray/Bucket1.heldQuantity, " ", level.newItem1.foodItemNamePlural)
			
		$Level/BucketTray/Bucket2.item = level.newItem2
		$Level/BucketTray/Bucket2.heldQuantity = level.newItem2.foodStartQuantity
		if $Level/BucketTray/Bucket2.heldQuantity == 1:
			$Level/BucketTray/Bucket2/Label.text = str($Level/BucketTray/Bucket2.heldQuantity, " ", level.newItem2.foodItemName)
		else:
			$Level/BucketTray/Bucket2/Label.text = str($Level/BucketTray/Bucket2.heldQuantity, " ", level.newItem2.foodItemNamePlural)
			
		$Level/BucketTray/Bucket3.item = level.newItem3
		$Level/BucketTray/Bucket3.heldQuantity = level.newItem3.foodStartQuantity
		if $Level/BucketTray/Bucket3.heldQuantity == 1:
			$Level/BucketTray/Bucket3/Label.text = str($Level/BucketTray/Bucket3.heldQuantity, " ", level.newItem3.foodItemName)
		else:
			$Level/BucketTray/Bucket3/Label.text = str($Level/BucketTray/Bucket3.heldQuantity, " ", level.newItem3.foodItemNamePlural)
			
		$Level/BucketTray/Bucket4.item = level.newItem4
		$Level/BucketTray/Bucket4.heldQuantity = level.newItem4.foodStartQuantity
		if $Level/BucketTray/Bucket4.heldQuantity == 1:
			$Level/BucketTray/Bucket4/Label.text = str($Level/BucketTray/Bucket4.heldQuantity, " ", level.newItem4.foodItemName)
		else:
			$Level/BucketTray/Bucket4/Label.text = str($Level/BucketTray/Bucket4.heldQuantity, " ", level.newItem4.foodItemNamePlural)
			
		$Level/BucketTray/Bucket5.item = level.newItem5
		$Level/BucketTray/Bucket5.heldQuantity = level.newItem5.foodStartQuantity
		if $Level/BucketTray/Bucket5.heldQuantity == 1:
			$Level/BucketTray/Bucket5/Label.text = str($Level/BucketTray/Bucket5.heldQuantity, " ", level.newItem5.foodItemName)
		else:
			$Level/BucketTray/Bucket5/Label.text = str($Level/BucketTray/Bucket5.heldQuantity, " ", level.newItem5.foodItemNamePlural)

func _nextLevel():
	currentLevel += 1
	if currentLevel < levels.size():
		loadLevel(levels[currentLevel])
	else:
		completedAll.emit()
