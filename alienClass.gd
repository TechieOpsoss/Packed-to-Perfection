extends Resource
class_name Alien

@export var has_restriction : bool #if yes tag applies else none
@export var name : String #unnecessary
@export var texture: Texture2D
@export var score : int = 100
@export var calories : int #needed number of calories per alien
@export var macronutrients : Dictionary = {"Protein": 8, "Carbohydrates": 5, "Fat": 5}
@export var tag : Dictionary = {"Dairy": 0, "Vegetarian": 0, "Gluten": 0}

#TODO I'm thinking of having a setter within shape duplicator, which then triggers an update to reciept based on food added into grid if we want the values to change in the receipt as a player inputs pieces
 
func _ready() -> void:
	pass
