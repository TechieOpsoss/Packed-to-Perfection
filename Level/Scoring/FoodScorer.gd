class_name FoodScorer extends Node2D

@export var restrictions: FoodItemStats
@export var toScore: FoodGrid

func _ready():
	hide()

func _show():
	# TODO: actually score
	$ScorePlaceholder.text = str(toScore.totalStats(), "\nOUT OF\n", restrictions)
	show()

func _hide():
	hide()
