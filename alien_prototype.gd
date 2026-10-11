extends Node2D
class_name Alien

@export var is_alien : bool
@export var has_restriction : bool #if yes tag applies else none
@export var alien_name : String #unnecessary
@export var score : int = 100
@export var calories : int #TODO: check with beck 0-300?
@export var macronutrients : Array #Protein, Carbohydrates, and Fat 0-10
@export var tag : String #TODO: For now listing as dairy, vegetarian, and gluten

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
