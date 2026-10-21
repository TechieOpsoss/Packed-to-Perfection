extends Button

@export var alienScore : int
@export var alienCal : int
@export var alienMacros : Dictionary = {"Protein": 0, "Carbohydrates": 0, "Fat": 0}
@export var alienTags: Dictionary = {"Dairy": 0, "Vegetarian": 0, "Gluten": 0}
@export var currentCals : int #number of calories per food item
@export var currentMacros : Dictionary = {"Protein": 0, "Carbohydrates": 0, "Fat": 0}
@export var tagsFound : Array[String] #can only be "Dairy", "Vegetarian", or "Gluten"
const MACRODEDUCTION = 10
const DIETARYDEDUCTION = 15
#TODO I'm thinking of having a setter within shape duplicator, which then triggers an update to reciept based on food added into grid if we want the values to change in the receipt as a player inputs pieces
 
func _ready() -> void:
	pass


func get_alien(alien: Node2D):
	alienScore = alien.alien_data.score
	alienCal = alien.alien_data.calories
	alienMacros = alien.alien_data.macronutrients
	#print("Found alien macros: ", alienMacros)
	alienTags = alien.alien_data.tag
	#print("Found alien tags: ", alienTags)

func get_current_values():
	pass

func _on_pressed() -> void:
	if currentMacros.Protein < alienMacros.Protein || currentMacros.Carbohydrates < alienMacros.Carbohydrates || currentMacros.Fat < alienMacros.Fat:
		alienScore = alienScore - MACRODEDUCTION
	if alienTags.find_key(1) != null:
		for tag in tagsFound:
			if tag == alienTags.find_key(1):
				alienScore = alienScore - DIETARYDEDUCTION
	
	pass # Replace with function body.
