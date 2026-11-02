class_name FoodScorer extends Node2D

@export var restrictions: FoodItemStats
@export var toScore: FoodGrid
var totalPassed: int = 0
var totalScore: int = 0
const BASE_SCORE: int = 100
const MACRO_DEDUCTION: int = 10
const DIETARY_DEDUCTION: int = 20
const WIN_THRESHOLD: int = 225

func _ready():
	hide()

func updateScore():
	var currentStats: FoodItemStats = toScore.totalStats()
	var proteinText = str(currentStats.nutrientA) + "/" + str(restrictions.nutrientA) + (str(" (-", MACRO_DEDUCTION, ")") if currentStats.nutrientA < restrictions.nutrientA else "")
	var carbText = str(currentStats.nutrientB) + "/" + str(restrictions.nutrientB) + (str(" (-", MACRO_DEDUCTION, ")") if currentStats.nutrientB < restrictions.nutrientB else "")
	var fatText = str(currentStats.nutrientC) + "/" + str(restrictions.nutrientC) + (str(" (-", MACRO_DEDUCTION, ")") if currentStats.nutrientC < restrictions.nutrientC else "")
	var calorieText = str(currentStats.calories) + "/" + str(restrictions.calories) + " (-" + str(cal_deduction(currentStats.calories, restrictions.calories)) + ")"
	
	var alienScore: int = calculate_score(currentStats)
	$ScoreBox/ScoreLabel.text = str("\n", calorieText, "\n", proteinText, "\n", carbText, "\n", fatText)
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

func calculate_score(currentStats: FoodItemStats) -> int:
	if currentStats.calories == 0 and currentStats.nutrientA == 0 and currentStats.nutrientB == 0 and currentStats.nutrientC == 0:
		return 0
	var score: int = BASE_SCORE
	score -= cal_deduction(currentStats.calories, restrictions.calories)
	if currentStats.nutrientA < restrictions.nutrientA:
		score -= MACRO_DEDUCTION
	if currentStats.nutrientB < restrictions.nutrientB:
		score -= MACRO_DEDUCTION
	if currentStats.nutrientC < restrictions.nutrientC:
		score -= MACRO_DEDUCTION
	if currentStats.tagA && restrictions.tagA:
		score -= DIETARY_DEDUCTION
	if currentStats.tagB && restrictions.tagB:
		score -= DIETARY_DEDUCTION
	if currentStats.tagC && restrictions.tagC:
		score -= DIETARY_DEDUCTION
	return max(0, score)

func end_score(finalCard):
	finalCard.text = "[b]Final Score\n" + str(max(0, totalScore))\
	+ ("/" + str(100 * totalPassed) + "[/b]\nYou Won" if totalScore > WIN_THRESHOLD else "/" + str(WIN_THRESHOLD) + "[/b]\nYou Lost")\
	+ "\n[i]Thanks for Playing![/i]"
