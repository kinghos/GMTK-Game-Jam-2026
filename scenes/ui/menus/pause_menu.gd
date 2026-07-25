extends CanvasLayer

@onready var button_container = $Control/ButtonContainer
@onready var settings: Control = $Control/Settings

func _on_resume_button_pressed() -> void:
	Globals.toggle_pause_menu()

func _on_settings_button_pressed() -> void:
	settings.show()
	button_container.hide()

func _on_menu_button_pressed() -> void:
	Globals.toggle_pause_menu()
	get_tree().change_scene_to_file("res://scenes/hud/title_screen.tscn")
