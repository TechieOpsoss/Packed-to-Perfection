class_name FoodBucketStatDisplay extends Control

func update(current: FoodItemStats, requirements: FoodItemStats):
	$Calories/Text.text = str("Cal\n", current.calories)
	$Protein/Text.text = str("Prot\n", current.nutrientA)
	$Carbs/Text.text = str("Carb\n", current.nutrientB)
	$Fat/Text.text = str("Fat\n", current.nutrientC)
	
	$Calories/Bar.size.y = $Calories.size.y * max(0.05,min(1, (current.calories as float) / (requirements.calories as float)))
	$Calories/Bar.position.y = $Calories.size.y - $Calories/Bar.size.y
	$Protein/Bar.size.y = $Protein.size.y * max(0.05,min(1, (current.nutrientA as float) / (requirements.nutrientA as float)))
	$Protein/Bar.position.y = $Protein.size.y - $Protein/Bar.size.y
	$Carbs/Bar.size.y = $Carbs.size.y * max(0.05,min(1, (current.nutrientB as float) / (requirements.nutrientB as float)))
	$Carbs/Bar.position.y = $Carbs.size.y - $Carbs/Bar.size.y
	$Fat/Bar.size.y = $Fat.size.y * max(0.05,min(1, (current.nutrientC as float) / (requirements.nutrientC as float)))
	$Fat/Bar.position.y = $Fat.size.y - $Fat/Bar.size.y
	
	$Dairy.visible = current.tagA
	$Meat.visible = current.tagB
	$Gluten.visible = current.tagC
