extends Control

func _ready() -> void:
	$Time.text = "FINAL TIME: " + Globals.time_elapsed
	$EnemiesKilled.text = "ENEMIES KILLED: " + str(int(Globals.enemy_kill_total))

func _on_play_again_pressed() -> void:
	Music.play_music(Music.MAIN_THEME, Music.main_theme_position)
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")


func _on_title_pressed() -> void:
	Music.play_music(Music.MAIN_THEME)
	Music.volume_db = 0
	get_tree().change_scene_to_file("res://scenes/hud/title_screen.tscn")
