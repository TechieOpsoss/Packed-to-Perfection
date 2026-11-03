extends Control

var master_bus_index = AudioServer.get_bus_index("Master")

#func _on_pressed_settings() -> void:
	#$SettingsPopUp.show()
	#print("show")
	#pass # Replace with function body.


func _on_exit_button_button_down() -> void:
	$Settings.hide()
	pass # Replace with function body.


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index,linear_to_db(value))
	pass # Replace with function body.
