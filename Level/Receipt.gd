class_name Receipt extends Panel

func update(current: FoodItemStats, requirements: FoodItemStats, customerName: String = "") -> void:
	if (customerName != ""):
		$ReceiptHeader.text = str(customerName, "'s Order")
	$ProteinsLabel.text = str("Proteins: ", current.nutrientA, "/", requirements.nutrientA)
	$CarbohydratesLabel.text = str("Carbohydrates: ", current.nutrientB, "/", requirements.nutrientB)
	$FatsLabel.text = str("Fats: ", current.nutrientC, "/", requirements.nutrientC)
	$CaloriesLabel.text = str("Calories: ", current.calories, "/", requirements.calories)
	if(requirements.tagA or requirements.tagB or requirements.tagC):
		$DietaryLabel.text = str("Dietary Restrictions:", " Dairy" if requirements.tagA else "", " Vegetarian" if requirements.tagB else "", " Gluten" if requirements.tagC else "")
	else:
		$DietaryLabel.text = ""
