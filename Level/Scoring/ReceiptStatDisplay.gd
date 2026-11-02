class_name ReceiptStatDisplay extends Control

var dairyColor = Color(1,0,1)
var meatColor = Color(1,0,1)
var glutenColor = Color(1,0,1)
func _ready():
	dairyColor = $Dairy.get_theme_color("font_color")
	meatColor = $Meat.get_theme_color("font_color")
	glutenColor = $Gluten.get_theme_color("font_color")

func update(current: FoodItemStats, requirements: FoodItemStats):
	#$Calories/Text.add_theme_color_override("font_color", lerp(Color(1,1,1), Color(1,0,0), abs(requirements.calories - current.calories) as float / requirements.calories))
	$Calories/Text.text = str(current.calories, "/", requirements.calories)
	#$Protein/Text.add_theme_color_override("font_color", Color(1,1,1) if current.nutrientA >= requirements.nutrientA else Color(1,0,0))
	$Protein/Text.text = str(current.nutrientA, "/", requirements.nutrientA)
	#$Carbs/Text.add_theme_color_override("font_color", Color(1,1,1) if current.nutrientB >= requirements.nutrientB else Color(1,0,0))
	$Carbs/Text.text = str(current.nutrientB, "/", requirements.nutrientB)
	#$Fat/Text.add_theme_color_override("font_color", Color(1,1,1) if current.nutrientC >= requirements.nutrientC else Color(1,0,0))
	$Fat/Text.text = str(current.nutrientC, "/", requirements.nutrientC)
	
	$Calories/Bar.size.x = max($Calories/Bar.size.y,$Calories.size.x * min(1, (current.calories as float) / (requirements.calories as float)))
	$Protein/Bar.size.x = max($Protein/Bar.size.y,$Protein.size.x * min(1, (current.nutrientA as float) / (requirements.nutrientA as float)))
	$Carbs/Bar.size.x = max($Carbs/Bar.size.y,$Carbs.size.x * min(1, (current.nutrientB as float) / (requirements.nutrientB as float)))
	$Fat/Bar.size.x = max($Fat/Bar.size.y,$Fat.size.x * min(1, (current.nutrientC as float) / (requirements.nutrientC as float)))
	
	#$Dairy.add_theme_color_override("font_color", Color(1,0,0) if current.tagA and requirements.tagA else dairyColor)
	$Dairy.visible = requirements.tagA
	#$Meat.add_theme_color_override("font_color", Color(1,0,0) if current.tagB and requirements.tagB else meatColor)
	$Meat.visible = requirements.tagB
	#$Gluten.add_theme_color_override("font_color", Color(1,0,0) if current.tagC and requirements.tagC else glutenColor)
	$Gluten.visible = requirements.tagC
