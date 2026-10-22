extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func create_receipt(alien: Node2D) -> void:
	$PanelContainer/VBoxContainer/ReceiptHeader.text = str(alien.alien_data.name) + "'s Receipt"
	$PanelContainer/VBoxContainer/ProteinsLabel.text = "Proteins: " + str(alien.alien_data.macronutrients["Protein"])
	$PanelContainer/VBoxContainer/CarbohydratesLabel.text = "Carbohydrates: " + str(alien.alien_data.macronutrients["Carbohydrates"])
	$PanelContainer/VBoxContainer/FatsLabel.text = "Fats: " + str(alien.alien_data.macronutrients["Fat"])
	$PanelContainer/VBoxContainer/CaloriesLabel.text = "Calories: " + str(alien.alien_data.calories)
	if(alien.alien_data.has_restriction && alien.alien_data.tag.find_key(1) != null):
		$PanelContainer/VBoxContainer/DietaryLabel.text = "Dietary Restrictions: " + str(alien.alien_data.tag.find_key(1))
	else:
		$PanelContainer/VBoxContainer/DietaryLabel.text = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
