class_name ScoreboxStatDisplay extends Control

func update(score: int, current: FoodItemStats, requirements: FoodItemStats):
	var potentialLostScoreDueToCalories: int = FoodScorer.cal_deduction(0, requirements.calories)
	var potentialLostScore: int = potentialLostScoreDueToCalories\
	+ FoodScorer.MACRO_DEDUCTION * 3\
	+ (FoodScorer.DIETARY_DEDUCTION if requirements.tagA else 0)\
	+ (FoodScorer.DIETARY_DEDUCTION if requirements.tagB else 0)\
	+ (FoodScorer.DIETARY_DEDUCTION if requirements.tagC else 0)
	
	$Backdrop/Calories.size.x = 0 if score == 0 else $Backdrop.size.x * min(1, abs(potentialLostScoreDueToCalories - FoodScorer.cal_deduction(current.calories, requirements.calories)) as float / potentialLostScore)
	$Backdrop/Protein.position.x = $Backdrop/Calories.size.x
	$Backdrop/Protein.size.x = 0 if score == 0 else $Backdrop.size.x * (FoodScorer.MACRO_DEDUCTION as float / potentialLostScore) if current.nutrientA >= requirements.nutrientA else 0
	$Backdrop/Carbs.position.x = $Backdrop/Protein.position.x + $Backdrop/Protein.size.x
	$Backdrop/Carbs.size.x = 0 if score == 0 else $Backdrop.size.x * (FoodScorer.MACRO_DEDUCTION as float / potentialLostScore) if current.nutrientB >= requirements.nutrientB else 0
	$Backdrop/Fat.position.x = $Backdrop/Carbs.position.x + $Backdrop/Carbs.size.x
	$Backdrop/Fat.size.x = 0 if score == 0 else $Backdrop.size.x * (FoodScorer.MACRO_DEDUCTION as float / potentialLostScore) if current.nutrientC >= requirements.nutrientC else 0
	
	$Backdrop/Dairy.size.x = 0 if score == 0 else $Backdrop.size.x * (FoodScorer.DIETARY_DEDUCTION as float / potentialLostScore) if requirements.tagA and not current.tagA else 0
	$Backdrop/Dairy.position.x = $Backdrop.size.x - $Backdrop/Dairy.size.x
	$Backdrop/Meat.size.x = 0 if score == 0 else $Backdrop.size.x * (FoodScorer.DIETARY_DEDUCTION as float / potentialLostScore) if requirements.tagB and not current.tagB else 0
	$Backdrop/Meat.position.x = $Backdrop/Dairy.position.x - $Backdrop/Meat.size.x
	$Backdrop/Gluten.size.x = 0 if score == 0 else $Backdrop.size.x * (FoodScorer.DIETARY_DEDUCTION as float / potentialLostScore) if requirements.tagC and not current.tagC else 0
	$Backdrop/Gluten.position.x = $Backdrop/Meat.position.x - $Backdrop/Gluten.size.x
