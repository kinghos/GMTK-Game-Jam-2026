extends AudioStreamPlayer

const MAIN_THEME = preload("uid://dql71kmw0qhyy")
const STATIC = preload("uid://brl7j7ipy0tgb")
var main_theme_position

func _ready() -> void:
	var filter = AudioEffectLowPassFilter.new()
	filter.cutoff_hz = 440
	AudioServer.add_bus(1)
	AudioServer.set_bus_name(1, "Music")
	AudioServer.add_bus(2)
	AudioServer.set_bus_name(2, "SFX")
	AudioServer.set_bus_volume_db(1, -4.0)
	AudioServer.add_bus_effect(AudioServer.get_bus_index("Music"), filter)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Music"), 0, false)
	bus = "Music"


func play_music(music: AudioStream, start_time = null):
	if stream == music:
		return
	stream = music
	bus = "Music"
	if start_time:
		play(start_time)
	else:
		play()

	
func save_position():
	main_theme_position = get_playback_position()
