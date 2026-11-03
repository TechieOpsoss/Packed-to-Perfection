extends CanvasLayer
@onready var settingsPage = $Settings
@onready var settingsButton = $SettingsButton

func _ready() -> void:
	settingsButton.button_down.connect(_on_pressed_settings)
	settingsPage.exit_settings.connect(on_exit_settingsPage)

func _on_pressed_settings() -> void:
	settingsPage.set_process(true)
	settingsPage.visible = true

func on_exit_settingsPage() -> void:
	settingsPage.visible = false
