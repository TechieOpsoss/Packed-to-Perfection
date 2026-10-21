class_name Scoring

class FoodItemStats:
	var calories: int
	var nutrientA: int
	var nutrientB: int
	var nutrientC: int
	var tagA: bool
	var tagB: bool
	var tagC: bool

@export var minCalories: int
@export var minNutrientA: int
@export var minNutrientB: int
@export var minNutrientC: int
@export var restrictTagA: bool
@export var restrictTagB: bool
@export var restrictTagC: bool

func score(_lunchBox: Array[FoodItemStats]) -> int:
	return 0 #TODO
