class_name FoodScorer extends Node2D

@export var restrictions: FoodItemStats
@export var toScore: FoodGrid
@onready var scoreCard: Label = $ScoreBox/ScoreLabel
var totalScore: int = 0
const MACRODEDUCTION = 5
const DIETARYDEDUCTION = 10
var currentStats: FoodItemStats
var alienScore: int = 100

func _ready():
	hide()

func printScore():
	currentStats = toScore.totalStats()
	var proteinText = "Proteins: " + str(currentStats.nutrientProtein) + " / " + str(restrictions.nutrientProtein)
	var carbText = "Carbohydrates: " + str(currentStats.nutrientB) + " / " + str(restrictions.nutrientB)
	var fatText = "Fats: " + str(currentStats.nutrientC) + " / " + str(restrictions.nutrientC)
	var calorieText = "Calories: " + str(currentStats.calories) + " / " + str(restrictions.calories)
	calculate_score()
	scoreCard.text = "SCORE:\n" + calorieText + "\n" + proteinText + "\n" + carbText + "\n" + fatText + "\nTotal Score: " + str(max(0, alienScore))
	totalScore = totalScore + alienScore
	

func _show():
	printScore()
	show()

func _hide():
	hide()

func cal_deduction(): # -1 for every 10 off by
	var overUnder = abs(restrictions.calories - currentStats.calories) / 10
	for num in overUnder:
		alienScore = alienScore - 1

func calculate_score():
	if currentStats.calories < restrictions.calories || currentStats.calories > restrictions.calories : #update
		cal_deduction()
	if currentStats.nutrientProtein < restrictions.nutrientProtein:
		alienScore = alienScore - MACRODEDUCTION
	if currentStats.nutrientB < restrictions.nutrientB:
		alienScore = alienScore - MACRODEDUCTION
	if currentStats.nutrientC < restrictions.nutrientC:
		alienScore = alienScore - MACRODEDUCTION
	if  currentStats.tagA == true && restrictions.tagA == true:
		alienScore = alienScore - DIETARYDEDUCTION
	if currentStats.tagB == true && restrictions.tagB == true:
		alienScore = alienScore - DIETARYDEDUCTION
	if currentStats.tagB == true && restrictions.tagC == true:
		alienScore = alienScore - DIETARYDEDUCTION

func end_score(finalCard):
	finalCard.text = "Final Score:\n" + str(max(0, totalScore)) + " / " + "300" + "\n\n Thanks for Playing!"
