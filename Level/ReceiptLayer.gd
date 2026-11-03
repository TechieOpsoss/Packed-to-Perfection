class_name ReceiptLayer extends CanvasLayer

func update(current: FoodItemStats, requirements: FoodItemStats, customerName: String = "") -> void:
	if (customerName != ""):
		$Receipt/ReceiptHeader.text = str(customerName, "'s Order")
	$Receipt/ProteinsLabel.text = str("Proteins: ", current.nutrientA, "/", requirements.nutrientA)
	$Receipt/CarbohydratesLabel.text = str("Carbohydrates: ", current.nutrientB, "/", requirements.nutrientB)
	$Receipt/FatsLabel.text = str("Fats: ", current.nutrientC, "/", requirements.nutrientC)
	$Receipt/CaloriesLabel.text = str("Calories: ", current.calories, "/", requirements.calories)
	if(requirements.tagA or requirements.tagB or requirements.tagC):
		$Receipt/DietaryLabel.text = str("Dietary Restrictions:", " Dairy" if requirements.tagA else "", " Vegetarian" if requirements.tagB else "", " Gluten" if requirements.tagC else "")
		$Receipt.size.y = 300
	else:
		$Receipt/DietaryLabel.text = ""
		$Receipt.size.y = 255
