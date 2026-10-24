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

func add(other: FoodItemStats) -> FoodItemStats:
	calories = calories + other.calories
	nutrientA = nutrientA + other.nutrientA
	nutrientB = nutrientB + other.nutrientB
	nutrientC = nutrientC + other.nutrientC
	tagA = tagA or other.tagA
	tagB = tagB or other.tagB
	tagC = tagC or other.tagC
	return self

func sumWith(other: FoodItemStats) -> FoodItemStats:
	var ret: FoodItemStats = FoodItemStats.new()
	ret.calories = calories + other.calories
	ret.nutrientA = nutrientA + other.nutrientA
	ret.nutrientB = nutrientB + other.nutrientB
	ret.nutrientC = nutrientC + other.nutrientC
	ret.tagA = tagA or other.tagA
	ret.tagB = tagB or other.tagB
	ret.tagC = tagC or other.tagC
	return ret
	
func _to_string() -> String:
	return str(calories, " Cal\nA ", nutrientA, " B ", nutrientB, " C ", nutrientC, "\n" if tagA or tagB or tagC else "", "a " if tagA else "", " b " if tagB else "", " c " if tagC else "")
