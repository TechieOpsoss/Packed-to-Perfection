extends Node2D

@export var currentLevel: int
@export var levels: Array[Level]

signal completedAll

func loadLevel(Level):
	pass

func _nextLevel():
	currentLevel += 1
	if currentLevel > levels.size():
		completedAll.emit()
	loadLevel(levels[currentLevel])
