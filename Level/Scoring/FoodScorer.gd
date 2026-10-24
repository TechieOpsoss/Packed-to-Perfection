class_name FoodScorer extends Node2D

@export var restrictions: FoodItemStats
@export var toScore: FoodGrid
@onready var scoreCard: Label = $ScoreBox/ScoreLabel
var totalScore: int = 0
const MACRO_DEDUCTION = 5
const DIETARY_DEDUCTION = 10
const WIN_THRESHOLD = 280
var currentStats: FoodItemStats

func _ready():
	hide()

func updateScore():
	currentStats = toScore.totalStats()
	var proteinText = "Proteins: " + str(currentStats.nutrientA) + " / " + str(restrictions.nutrientA)
	var carbText = "Carbohydrates: " + str(currentStats.nutrientB) + " / " + str(restrictions.nutrientB)
	var fatText = "Fats: " + str(currentStats.nutrientC) + " / " + str(restrictions.nutrientC)
	var calorieText = "Calories: " + str(currentStats.calories) + " / " + str(restrictions.calories)
	
	var alienScore: int = calculate_score()
	scoreCard.text = str("SCORE:\n", calorieText, "\n", proteinText, "\n", carbText, "\n", fatText, "\nTotal Score: ", alienScore)
	totalScore = totalScore + alienScore

func _show():
	updateScore()
	show()

func _hide():
	hide()

func cal_deduction() -> int: # -1 for every 10 off by
	var overUnder = abs(restrictions.calories - currentStats.calories) / 10
	return floor(overUnder) as int

func calculate_score() -> int:
	var score: int = 100
	if currentStats.calories < restrictions.calories || currentStats.calories > restrictions.calories : #update
		score -= cal_deduction()
	if currentStats.nutrientA < restrictions.nutrientA:
		score -= MACRO_DEDUCTION
	if currentStats.nutrientB < restrictions.nutrientB:
		score -= MACRO_DEDUCTION
	if currentStats.nutrientC < restrictions.nutrientC:
		score -= MACRO_DEDUCTION
	if  currentStats.tagA == true && restrictions.tagA == true:
		score -= DIETARY_DEDUCTION
	if currentStats.tagB == true && restrictions.tagB == true:
		score -= DIETARY_DEDUCTION
	if currentStats.tagB == true && restrictions.tagC == true:
		score -= DIETARY_DEDUCTION
	return max(0, score)

func end_score(finalCard):
	finalCard.text = "Final Score:\n" + str(max(0, totalScore)) + " / " + "300" + "\n\n" + ("You Won" if totalScore > WIN_THRESHOLD else "You Lost") + "\nThanks for Playing!"
