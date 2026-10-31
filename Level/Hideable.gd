extends CanvasItem

@export var startHidden = false

func _ready():
	if startHidden:
		_hide()
	else:
		_show()

func _show():
	show()

func _hide():
	hide()
