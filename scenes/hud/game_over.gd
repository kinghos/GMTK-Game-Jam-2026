extends Control

func _ready() -> void:
	$Time.text = "FINAL TIME: " + Globals.time_elapsed

func _on_button_pressed() -> void:
	Music.play_music(Music.MAIN_THEME, Music.main_theme_position)
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
