extends Control
@onready var exit_button = $SettingsPopUp/MarginContainer2/ExitButton
var master_bus_index = AudioServer.get_bus_index("Master")
signal exit_settings

func _ready():
	exit_button.button_down.connect(_on_exit_button_button_down)
	set_process(false)

func _on_exit_button_button_down() -> void:
	exit_settings.emit()
	set_process(false)


func _on_master_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index,linear_to_db(value))
