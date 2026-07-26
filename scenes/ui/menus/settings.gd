extends Control

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	var buses = [master_bus_index, music_bus_index, sfx_bus_index]
	var i = 0
	for slider in $VBoxContainer.get_children():
		if slider is HSlider:
			slider.value = db_to_linear(AudioServer.get_bus_volume_db(buses[i]))
			i += 1

func _on_back_pressed() -> void:
	if get_tree().is_paused() and Globals.pause_menu.visible == true:
		hide()
		Globals.pause_menu.get_node("Control/ButtonContainer").show()
	else:
		get_tree().change_scene_to_file("res://scenes/hud/title_screen.tscn")
	


func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(value))


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))
