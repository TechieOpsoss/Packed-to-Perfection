class_name StatDisplay extends Control

var dairyColor = Color(1,0,1)
var meatColor = Color(1,0,1)
var glutenColor = Color(1,0,1)
func _ready():
	dairyColor = $Dairy.get_theme_color("font_color")
	meatColor = $Meat.get_theme_color("font_color")
	glutenColor = $Gluten.get_theme_color("font_color")

func update(current: FoodItemStats, requirements: FoodItemStats):
	$Calories/Text.remove_theme_color_override("font_color")
	$Calories/Text.add_theme_color_override("font_color", lerp(Color(1,1,1), Color(1,0,0), abs(requirements.calories - current.calories) as float / requirements.calories))
	$Calories/Text.text = str(current.calories, "/", requirements.calories)
	$Protein/Text.remove_theme_color_override("font_color")
	$Protein/Text.add_theme_color_override("font_color", Color(1,1,1) if current.nutrientA >= requirements.nutrientA else Color(1,0,0))
	$Protein/Text.text = str(current.nutrientA, "/", requirements.nutrientA)
	$Carbs/Text.remove_theme_color_override("font_color")
	$Carbs/Text.add_theme_color_override("font_color", Color(1,1,1) if current.nutrientB >= requirements.nutrientB else Color(1,0,0))
	$Carbs/Text.text = str(current.nutrientB, "/", requirements.nutrientB)
	$Fat/Text.remove_theme_color_override("font_color")
	$Fat/Text.add_theme_color_override("font_color", Color(1,1,1) if current.nutrientC >= requirements.nutrientC else Color(1,0,0))
	$Fat/Text.text = str(current.nutrientC, "/", requirements.nutrientC)
	$Calories/Bar.size.x = $Calories.size.x * max(0.05,min(1, (current.calories as float) / (requirements.calories as float)))
	$Protein/Bar.size.x = $Protein.size.x * max(0.05,min(1, (current.nutrientA as float) / (requirements.nutrientA as float)))
	$Carbs/Bar.size.x = $Carbs.size.x * max(0.05,min(1, (current.nutrientB as float) / (requirements.nutrientB as float)))
	$Fat/Bar.size.x = $Fat.size.x * max(0.05,min(1, (current.nutrientC as float) / (requirements.nutrientC as float)))
	$Dairy.remove_theme_color_override("font_color")
	$Dairy.add_theme_color_override("font_color", Color(1,0,0) if current.tagA and requirements.tagA else dairyColor)
	$Dairy.visible = requirements.tagA
	$Meat.remove_theme_color_override("font_color")
	$Meat.add_theme_color_override("font_color", Color(1,0,0) if current.tagB and requirements.tagB else meatColor)
	$Meat.visible = requirements.tagB
	$Gluten.remove_theme_color_override("font_color")
	$Gluten.add_theme_color_override("font_color", Color(1,0,0) if current.tagC and requirements.tagC else glutenColor)
	$Gluten.visible = requirements.tagC
