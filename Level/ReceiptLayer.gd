extends CanvasLayer

func update(customerName: String, requirements: FoodItemStats) -> void:
	$Receipt/ReceiptHeader.text = str(customerName, "'s Order")
	$Receipt/ProteinsLabel.text = str("Proteins: ", requirements.nutrientProtein)
	$Receipt/CarbohydratesLabel.text = str("Carbohydrates: ", requirements.nutrientB)
	$Receipt/FatsLabel.text = str("Fats: ", requirements.nutrientC)
	$Receipt/CaloriesLabel.text = str("Calories: ", requirements.calories)
	if(requirements.tagA or requirements.tagB or requirements.tagC):
		$Receipt/DietaryLabel.text = str("Dietary Restrictions:", " Dairy" if requirements.tagA else "", " Vegetarian" if requirements.tagB else "", " Gluten" if requirements.tagC else "")
	else:
		$Receipt/DietaryLabel.text = ""
