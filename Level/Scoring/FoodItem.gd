class_name FoodItem extends Resource

@export var foodStartQuantity: int = 10
@export var foodItemName: String = "Food Item"
@export var foodItemNamePlural: String = "Food Items"
@export var shape: Array[Vector2i] = [Vector2i(0,0)]
@export var stats: FoodItemStats

func _init(p_foodStartQuantity: int = 10, p_foodItemName: String = "Food Item", p_foodItemNamePlural: String = "Food Items", p_stats: FoodItemStats = FoodItemStats.new()):
	foodStartQuantity = p_foodStartQuantity
	foodItemName = p_foodItemName
	foodItemNamePlural = p_foodItemNamePlural
	stats = p_stats

func _to_string() -> String:
	return str("\"", foodItemName, "\": ", stats)
