class_name StatDisplay extends Control

func update(current: FoodItemStats, requirements: FoodItemStats):
	$Calories/Text.text = str(current.calories, "/", requirements.calories)
	$Protein/Text.text = str(current.nutrientA, "/", requirements.nutrientA)
	$Carbs/Text.text = str(current.nutrientB, "/", requirements.nutrientB)
	$Fat/Text.text = str(current.nutrientC, "/", requirements.nutrientC)
	$Calories/Bar.size.x = $Calories.size.x * max(0.05,min(1, (current.calories as float) / (requirements.calories as float)))
	$Protein/Bar.size.x = $Protein.size.x * max(0.05,min(1, (current.nutrientA as float) / (requirements.nutrientA as float)))
	$Carbs/Bar.size.x = $Carbs.size.x * max(0.05,min(1, (current.nutrientB as float) / (requirements.nutrientB as float)))
	$Fat/Bar.size.x = $Fat.size.x * max(0.05,min(1, (current.nutrientC as float) / (requirements.nutrientC as float)))
	$Dairy.visible = requirements.tagA
	$Meat.visible = requirements.tagB
	$Gluten.visible = requirements.tagC
