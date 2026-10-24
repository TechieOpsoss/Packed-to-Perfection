extends Node2D

enum uiState {
	GAMEPLAY,
	SCORING
}
signal select_alien()
var currentState = uiState.GAMEPLAY
@export var alienScore : int
@export var alienCal : int
@export var alienMacros : Dictionary = {"Protein": 0, "Carbohydrates": 0, "Fat": 0}
@export var alienTags: Dictionary = {"Dairy": 0, "Vegetarian": 0, "Gluten": 0}
@export var currentCals : int #number of calories per food item
@export var currentMacros : Dictionary = {"Protein": 0, "Carbohydrates": 0, "Fat": 0}
@export var tagsFound : Array[String] #can only be "Dairy", "Vegetarian", or "Gluten"
var totalScore : int = 0
const MACRODEDUCTION = 10
const DIETARYDEDUCTION = 15
@onready var scoreBox = $"GridLayer/ScoreBox"
@onready var scoreLabel = $GridLayer/ScoreBox/ScoreLabel
@onready var button = $Lunch_Bar/Submit_Button
@onready var lunchbox = $GridLayer/Lunchbox
#TODO I'm thinking of having a setter within shape duplicator, which then triggers an update to reciept based on food added into grid if we want the values to change in the receipt as a player inputs pieces
 
func _ready() -> void:
	scoreBox.hide()
	button.text = "Submit"
	$"..".end_level.connect(end_score)

#called after alien created
func get_alien(alien: Node2D): 
	alienScore = alien.alien_data.score
	alienCal = alien.alien_data.calories
	alienMacros = alien.alien_data.macronutrients
	alienTags = alien.alien_data.tag

#called when grid is full or after submit clicked (TODO: needs implementation)
func get_current_values(current: Node2D):
	currentCals = current.calories
	currentMacros = current.macronutrients
	tagsFound = current.tag
	# TODO put in grid values connected to current values

func _on_pressed() -> void:
	if currentState == uiState.GAMEPLAY:
		show_results()
	else:
		next_level()

func show_results():
	calculate_score()
	lunchbox.hide()
	scoreLabel.text = "Score: " + str(alienScore) #TODO: Update with breakdown of scoring
	totalScore += alienScore
	scoreBox.show()
	button.text = "Continue"
	currentState = uiState.SCORING
	

func calculate_score():
	if currentMacros.Protein < alienMacros.Protein:
		alienScore = alienScore - MACRODEDUCTION
	if currentMacros.Carbohydrates < alienMacros.Carbohydrates:
		alienScore = alienScore - MACRODEDUCTION
	if currentMacros.Fat < alienMacros.Fat:
		alienScore = alienScore - MACRODEDUCTION
	if alienTags.find_key(1) != null: #TODO: Needs to be tested as no tags in array currently
		for tag in tagsFound:
			if tag == alienTags.find_key(1):
				print("dietary deduction applied")
				alienScore = alienScore - DIETARYDEDUCTION

func next_level():
	print("on to the next level")
	select_alien.emit()
	scoreBox.hide()
	lunchbox.show()
	button.text = "Submit"
	currentState = uiState.GAMEPLAY
	pass
	
func end_score():
	get_tree().change_scene_to_file("res://Scenes/EndScore.tscn")
	print("end game")
	pass
