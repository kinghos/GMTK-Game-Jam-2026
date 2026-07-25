extends Control

func _ready() -> void:
	Music.play_music(Music.MAIN_THEME)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/credits.tscn")
