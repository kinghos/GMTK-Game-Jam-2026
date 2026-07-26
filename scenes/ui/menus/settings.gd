extends Control

# Store bus names rather than caching potentially invalid indices at script load
const BUS_MASTER := "Master"
const BUS_MUSIC := "Music"
const BUS_SFX := "SFX"

@onready var master_slider: HSlider = $VBoxContainer/MasterSlider # Adjust node paths if named differently
@onready var music_slider: HSlider = $VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $VBoxContainer/SFXSlider

func _ready() -> void:
	call_deferred("_initialize_sliders")

func _initialize_sliders() -> void:
	_setup_slider(BUS_MASTER, master_slider)
	_setup_slider(BUS_MUSIC, music_slider)
	_setup_slider(BUS_SFX, sfx_slider)

func _setup_slider(bus_name: String, slider: HSlider) -> void:
	if slider == null:
		return
		
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _set_bus_volume_by_name(bus_name: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)
	if bus_index != -1:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))

func _on_back_pressed() -> void:
	if get_tree().is_paused() and Globals.pause_menu.visible == true:
		hide()
		Globals.pause_menu.get_node("Control/ButtonContainer").show()
	else:
		get_tree().change_scene_to_file("res://scenes/hud/title_screen.tscn")

func _on_master_slider_value_changed(value: float) -> void:
	_set_bus_volume_by_name(BUS_MASTER, value)

func _on_music_slider_value_changed(value: float) -> void:
	_set_bus_volume_by_name(BUS_MUSIC, value)

func _on_sfx_slider_value_changed(value: float) -> void:
	_set_bus_volume_by_name(BUS_SFX, value)
