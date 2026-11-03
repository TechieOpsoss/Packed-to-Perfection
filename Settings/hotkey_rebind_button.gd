class_name HotKeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button


@export var action_name : String = "shape_rotate_ccw"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_key()
	
func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"shape_rotate_ccw":
			label.text = "Rotate Left"
		"shape_rotate_cw":
			label.text = "Rotate Right"

func set_text_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	print(action_keycode)
	
	button.text = str(action_keycode)


func _on_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
	else:
		set_text_key()
	pass # Replace with function body.
