extends CanvasLayer

@onready var button_container = $Control/ButtonContainer
@onready var settings: Control = $Control/Settings
@onready var paused_time_ms = 0.0

func _process(delta: float) -> void:
	if visible:
		paused_time_ms += delta * 1000

func _on_resume_button_pressed() -> void:
	Globals.start_time += floori(paused_time_ms)
	paused_time_ms = 0.0
	Globals.toggle_pause_menu()

func _on_settings_button_pressed() -> void:
	settings.show()
	button_container.hide()

func _on_menu_button_pressed() -> void:
	Globals.toggle_pause_menu()
	get_tree().change_scene_to_file("res://scenes/hud/title_screen.tscn")
