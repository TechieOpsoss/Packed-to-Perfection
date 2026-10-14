extends CanvasLayer

@onready var protein_label: Label = $Receipt/ProteinsLabel
@onready var carbs_label: Label = $Receipt/CarbohydratesLabel
@onready var fat_label: Label = $Receipt/FatsLabel
@onready var calorie_label: Label = $Receipt/CaloriesLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	protein_label.text = "Proteins: " + str(7)
	carbs_label.text = "Carbohydrates: " + str(15)
	fat_label.text = "Fats: " + str(8)
	calorie_label.text = "Calories: " + str(27)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
