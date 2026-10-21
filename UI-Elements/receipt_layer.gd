extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func create_receipt(alien: Node2D) -> void:
	$Receipt/ReceiptHeader.text = str(alien.alien_data.name) + "'s Receipt"
	$Receipt/ProteinsLabel.text = "Proteins: " + str(alien.alien_data.macronutrients["Protein"])
	$Receipt/CarbohydratesLabel.text = "Carbohydrates: " + str(alien.alien_data.macronutrients["Carbohydrates"])
	$Receipt/FatsLabel.text = "Fats: " + str(alien.alien_data.macronutrients["Fat"])
	$Receipt/CaloriesLabel.text = "Calories: " + str(alien.alien_data.calories)
	if(alien.alien_data.has_restriction && alien.alien_data.tag.find_key(1) != null):
		$Receipt/DietaryLabel.text = "Dietary Restrictions: " + str(alien.alien_data.tag.find_key(1))
	else:
		$Receipt/DietaryLabel.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
