extends Control


func _on_back_pressed() -> void:
	if get_tree().is_paused() and Globals.pause_menu.visible == true:
		hide()
		Globals.pause_menu.get_node("Control/ButtonContainer").show()
	else:
		get_tree().change_scene_to_file("res://scenes/hud/title_screen.tscn")
