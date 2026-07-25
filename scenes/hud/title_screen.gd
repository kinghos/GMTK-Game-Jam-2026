extends Control

func _ready() -> void:
	Music.play_music(Music.MAIN_THEME)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/menus/opening_cutscene.tscn")


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/credits.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
