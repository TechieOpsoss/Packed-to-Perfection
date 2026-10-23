class_name FoodItemStats extends Resource
@export var calories: int
@export var nutrientA: int
@export var nutrientB: int
@export var nutrientC: int
@export var tagA: bool
@export var tagB: bool
@export var tagC: bool
func _init(p_calories: int = 0, p_nutrientA: int = 0, p_nutrientB: int = 0, p_nutrientC: int = 0, p_tagA: bool = false, p_tagB: bool = false, p_tagC: bool = false):
	calories = p_calories
	nutrientA = p_nutrientA
	nutrientB = p_nutrientB
	nutrientC = p_nutrientC
	tagA = p_tagA
	tagB = p_tagB
	tagC = p_tagC
