extends Control


func _on_button_pressed() -> void:
	Music.resume_at_pos()
	get_tree().change_scene_to_file("res://scenes/level/level.tscn")
