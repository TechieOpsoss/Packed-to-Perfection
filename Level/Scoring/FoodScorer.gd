class_name FoodScorer extends Node2D

@export var toScore: FoodGrid

func _ready():
	hide()

func _show():
	# TODO: actually score
	$ScorePlaceholder.text = str(toScore.totalStats())
	show()

func _hide():
	hide()
