class_name Receipt extends Panel
var currentName: String = ""

func update(current: FoodItemStats, requirements: FoodItemStats, customerName: String = "") -> void:
	if customerName != "":
		currentName = customerName
	$CenteredText.text = str("\n", str(currentName, "'s ") if (currentName != "") else "",
	"Dietary Needs\n\n\n\n\n\n\n\n\n",
	"Dietary Restrictions" if (requirements.tagA or requirements.tagB or requirements.tagC) else "No Dietary Restrictions")
	$StatDisplay.update(current, requirements)
