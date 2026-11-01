class_name FoodScorer extends Node2D

@export var restrictions: FoodItemStats
@export var toScore: FoodGrid
var totalPassed: int = 0
var totalScore: int = 0
const BASE_SCORE: int = 100
const MACRO_DEDUCTION: int = 10
const DIETARY_DEDUCTION: int = 20
const WIN_THRESHOLD: int = 225
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
	$ScoreBox/ScoreLabel.text = str("SCORE:\n", calorieText, "\n", proteinText, "\n", carbText, "\n", fatText, "\nTotal Score: ", alienScore)
	$ScoreBox/StatDisplay.update(alienScore, currentStats, restrictions)
	totalScore += alienScore
	totalPassed += 1

func _show():
	updateScore()
	show()

func _hide():
	hide()

static func cal_deduction(calories: int, requiredCalories: int) -> int: # -1 for every 10 off by
	var difference = abs(requiredCalories - calories)
	return floor(difference as float / 10) as int

func calculate_score() -> int:
	if currentStats.calories == 0 and currentStats.nutrientA == 0 and currentStats.nutrientB == 0 and currentStats.nutrientC == 0:
		return 0
	var score: int = BASE_SCORE
	if currentStats.calories < restrictions.calories || currentStats.calories > restrictions.calories : #update
		score -= cal_deduction(currentStats.calories, restrictions.calories)
	if currentStats.nutrientA < restrictions.nutrientA:
		score -= MACRO_DEDUCTION
	if currentStats.nutrientB < restrictions.nutrientB:
		score -= MACRO_DEDUCTION
	if currentStats.nutrientC < restrictions.nutrientC:
		score -= MACRO_DEDUCTION
	if  currentStats.tagA && restrictions.tagA:
		score -= DIETARY_DEDUCTION
	if currentStats.tagB && restrictions.tagB:
		score -= DIETARY_DEDUCTION
	if currentStats.tagB && restrictions.tagC:
		score -= DIETARY_DEDUCTION
	return max(0, score)

func end_score(finalCard):
	finalCard.text = "Final Score:\n" + str(max(0, totalScore))\
	+ ("/" + str(100 * totalPassed) + "\n\nYou Won" if totalScore > WIN_THRESHOLD else "/" + str(WIN_THRESHOLD) + "\n\nYou Lost")\
	+ "\nThanks for Playing!"
